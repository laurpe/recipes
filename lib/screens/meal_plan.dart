import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/meal_plan/bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/grocery.dart';
import 'package:recipes/helpers/add_ingredients_to_groceries.dart';
import 'package:recipes/models/meal_plan.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/screens/edit_meal_plan.dart';

// TODO: make this and recipe result use same class
sealed class Result<T> {
  final T? data;

  Result(this.data);
}

class Updated extends Result<MealPlan> {
  Updated(MealPlan super.data);
}

class Deleted extends Result<int> {
  Deleted(int super.data);
}

class Added extends Result<MealPlan> {
  Added(MealPlan super.data);
}

Future<void> addMealplanToGroceries(
    MealPlan mealPlan, BuildContext context) async {
  final databaseClient = GetIt.I<DatabaseClient>();
  final recipes = await databaseClient.getMealPlanRecipes(mealPlan.id!);

  /// TODO: could be optimized by adding all groceries at once
  try {
    for (var recipe in recipes) {
      await addIngredientsToGroceries(recipe, mealPlan.servingsPerMeal);
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meal plan added to grocery list!'),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not add meal plan to grocery list.'),
      ),
    );
  }
}

Future<void> addGroceries(
    Recipe recipe, int servings, BuildContext context) async {
  final databaseClient = GetIt.I<DatabaseClient>();
  final groceries = await databaseClient.getGroceries();
  final ingredients = recipe.ingredients;
  final List<Grocery> newGroceries = [];
  final int timestamp = DateTime.now().millisecondsSinceEpoch;

  for (var ingredient in ingredients) {
    newGroceries.add(
      Grocery(
        name: ingredient.name,
        amount: ingredient.amountPerServing * servings,
        unit: ingredient.unit,
        isBought: false,
        listOrder: timestamp + ingredients.indexOf(ingredient),
      ),
    );
  }

  final allGroceries = groceries + newGroceries;

  /// Converts grocery units to default units
  Grocery unitsToDefaults(Grocery grocery) {
    switch (grocery.unit) {
      case 'tl':
        return grocery.copyWith(amount: grocery.amount * 5, unit: 'ml');
      case 'rkl':
        return grocery.copyWith(amount: grocery.amount * 15, unit: 'ml');
      case 'cl':
        return grocery.copyWith(amount: grocery.amount * 10, unit: 'ml');
      case 'dl':
        return grocery.copyWith(amount: grocery.amount * 100, unit: 'ml');
      case 'l':
        return grocery.copyWith(amount: grocery.amount * 1000, unit: 'ml');
      case 'kg':
        return grocery.copyWith(amount: grocery.amount * 1000, unit: 'g');
      default:
        return grocery;
    }
  }

  List<Grocery> unitCorrectedGroceries = [];

  for (var grocery in allGroceries) {
    unitCorrectedGroceries.add(unitsToDefaults(grocery));
  }

  Map<String, Grocery> resultMap =
      unitCorrectedGroceries.fold(<String, Grocery>{}, (accumulator, grocery) {
    if (accumulator.containsKey(grocery.name)) {
      accumulator[grocery.name] = Grocery(
          id: accumulator[grocery.name]!.id,
          name: grocery.name,
          amount: accumulator[grocery.name]!.amount + grocery.amount,
          unit: accumulator[grocery.name]!.unit,
          isBought: accumulator[grocery.name]!.isBought,
          listOrder: accumulator[grocery.name]!.listOrder);
      return accumulator;
    }
    accumulator[grocery.name] = grocery;
    return accumulator;
  });

  List<Grocery> finalList = resultMap.values.toList();

  try {
    for (var grocery in finalList) {
      grocery.id == null
          ? await databaseClient.insertGrocery(grocery)
          : await databaseClient.updateGrocery(grocery);
    }
  } catch (error) {
    rethrow;
  }
}

Future<void> openEditMealPlan(BuildContext context, MealPlan mealPlan) async {
  final Result? result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditMealPlan(mealPlan: mealPlan),
    ),
  );

  if (!context.mounted) return;

  if (result is Updated) {
    BlocProvider.of<MealPlanBloc>(context).add(GetMealPlan());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meal Plan updated!'),
      ),
    );
  }
}

Future confirmMealPlanDelete(BuildContext context, int mealPlanId) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm delete'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this meal plan?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              try {
                await GetIt.I<DatabaseClient>().deleteMealPlan(mealPlanId);

                if (!context.mounted) return;

                Navigator.of(context).pop(Deleted(mealPlanId));
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Could not delete meal plan! Please try again.')));
              }
            },
          )
        ],
      );
    },
  );
}

class SingleMealPlan extends StatelessWidget {
  final int mealPlanId;

  const SingleMealPlan({super.key, required this.mealPlanId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          final databaseClient = GetIt.I<DatabaseClient>();
          return MealPlanBloc(
              databaseClient: databaseClient, mealPlanId: mealPlanId)
            ..add(GetMealPlan());
        },
        child: const SingleMealPlanView());
  }
}

class SingleMealPlanView extends StatelessWidget {
  const SingleMealPlanView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealPlanBloc, MealPlanState>(
      builder: (context, state) {
        switch (state) {
          case LoadingMealPlanState():
            return const Center(child: CircularProgressIndicator());
          case ErrorLoadingMealPlanState():
            return const Center(child: Text('Error loading meal plan'));
          case LoadedMealPlanState():
            return Scaffold(
              appBar: AppBar(
                title: Text(state.mealPlan.name),
                centerTitle: false,
                leading: IconButton(
                    onPressed: () =>
                        Navigator.of(context).pop(Updated(state.mealPlan)),
                    icon: const Icon(Icons.arrow_back_ios)),
                actions: [
                  MenuAnchor(
                    builder: (context, controller, child) {
                      return IconButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'Show menu',
                      );
                    },
                    menuChildren: [
                      MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                        onPressed: () {
                          openEditMealPlan(context, state.mealPlan);
                        },
                      ),
                      MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                        onPressed: () async {
                          final Result? result = await confirmMealPlanDelete(
                              context, state.mealPlan.id!);
                          if (result is Deleted) {
                            if (!context.mounted) return;

                            Navigator.of(context).pop(Deleted(result.data!));
                          }
                        },
                      ),
                      MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.add_shopping_cart),
                            SizedBox(width: 8),
                            Text('Add to groceries'),
                          ],
                        ),
                        onPressed: () {
                          addMealplanToGroceries(state.mealPlan, context);
                        },
                      ),
                    ],
                  )
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                    child: Text(
                        'Servings per meal: ${state.mealPlan.servingsPerMeal}'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.mealPlan.days!.length,
                      itemBuilder: (context, index) {
                        final day = state.mealPlan.days![index];
                        return Card(
                          child: ListTile(
                            title: Text(day.name),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var meal in day.meals) ...[
                                    Text('${meal.name}: ${meal.recipeName}')
                                  ],
                                  Text(
                                    'Macros per person: '
                                    'Carbs: ${day.meals.fold(0.0, (sum, meal) => sum + (meal.carbohydratesPerServing ?? 0.0))}, '
                                    'Protein: ${day.meals.fold(0.0, (sum, meal) => sum + (meal.proteinPerServing ?? 0.0))}, '
                                    'Fat: ${day.meals.fold(0.0, (sum, meal) => sum + (meal.fatPerServing ?? 0.0))}, '
                                    'Calories: ${day.meals.fold(0.0, (sum, meal) => sum + (meal.caloriesPerServing ?? 0.0))}',
                                  ),
                                ]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
