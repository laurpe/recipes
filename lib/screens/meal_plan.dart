import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/meal_plan/bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/grocery.dart';
import 'package:recipes/meal_plan.dart';
import 'package:recipes/recipe.dart';
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

// TODO: every recipe gives notification 'ingredients added to grocery list'
// TODO: serving sizes for meal plan meals for correct amount of groceries
Future<void> addGroceriesFromMealPlan(
    MealPlan mealPlan, BuildContext context) async {
  final databaseClient = GetIt.I<DatabaseClient>();
  final recipes = await databaseClient.getMealPlanRecipes(mealPlan.id!);

  for (var recipe in recipes) {
    if (!context.mounted) return;
    await addGroceries(recipe, context);
  }
}

Future<void> addGroceries(Recipe recipe, BuildContext context) async {
  final databaseClient = GetIt.I<DatabaseClient>();
  final groceries = await databaseClient.getGroceries();
  final ingredients = recipe.ingredients;
  final List<Grocery> newGroceries = [];
  final int timestamp = DateTime.now().millisecondsSinceEpoch;

  for (var ingredient in ingredients) {
    newGroceries.add(
      Grocery(
        name: ingredient.name,
        amount: ingredient.amount,
        unit: ingredient.unit,
        isBought: false,
        listOrder: timestamp + ingredients.indexOf(ingredient),
      ),
    );
  }

  final allGroceries = groceries + newGroceries;

  /// Converts amount to string without decimal places if it's a whole number
  String amountToString(double amount) {
    String amountAsString = amount.toString();
    return amountAsString.contains('.0')
        ? amountAsString.split('.0')[0]
        : amountAsString;
  }

  /// Converts grocery units to default units
  Grocery unitsToDefaults(Grocery grocery) {
    switch (grocery.unit) {
      case 'tl':
        return grocery.copyWith(
            amount: amountToString(double.parse(grocery.amount) * 5),
            unit: 'ml');
      case 'rkl':
        return grocery.copyWith(
            amount: amountToString(double.parse(grocery.amount) * 15),
            unit: 'ml');
      case 'cl':
        return grocery.copyWith(
            amount: amountToString(double.parse(grocery.amount) * 10),
            unit: 'ml');
      case 'dl':
        return grocery.copyWith(
            amount: amountToString(double.parse(grocery.amount) * 100),
            unit: 'ml');
      case 'l':
        return grocery.copyWith(
            amount: amountToString(double.parse(grocery.amount) * 1000),
            unit: 'ml');
      case 'kg':
        return grocery.copyWith(
            amount: amountToString(double.parse(grocery.amount) * 1000),
            unit: 'g');
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
          amount: amountToString(
              double.parse(accumulator[grocery.name]!.amount) +
                  double.parse(grocery.amount)),
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
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ingredients added to grocery list!'),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not add ingredients to grocery list!'),
      ),
    );
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
                          addGroceriesFromMealPlan(state.mealPlan, context);
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
                                  for (var meal in day.meals)
                                    Text('${meal.name}: ${meal.recipeName}'),
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
