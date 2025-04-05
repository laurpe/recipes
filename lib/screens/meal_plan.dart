import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/meal_plan/bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/helpers/number_formatters.dart';
import 'package:recipes/helpers/add_ingredients_to_groceries.dart';
import 'package:recipes/models/meal_plan.dart';
import 'package:recipes/repositories/meal_plan_repository.dart';
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
  final mealPlanRepository = GetIt.I<MealPlanRepository>();
  final ingredients =
      await mealPlanRepository.getMealPlanIngredients(mealPlan.id!);

  try {
    await addIngredientsToGroceries(ingredients);

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
                await GetIt.I<AppDatabase>()
                    .mealPlansDao
                    .deleteMealPlan(mealPlanId);

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
          final mealPlanRepository = GetIt.I<MealPlanRepository>();
          return MealPlanBloc(
              mealPlanRepository: mealPlanRepository, mealPlanId: mealPlanId)
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
                            title: Text(day.name,
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var meal in day.meals) ...[
                                    Text('${meal.name}: ${meal.recipeName}')
                                  ],
                                  Divider(),
                                  Text('Macros per person:'),
                                  Text(
                                    'Carbs: ${removeTrailingZero(day.getCarbsPerPerson())} g, '
                                    'Protein: ${removeTrailingZero(day.getProteinPerPerson())} g, '
                                    'Fat: ${removeTrailingZero(day.getFatPerPerson())} g, '
                                    'Calories: ${removeTrailingZero(day.getCaloriesPerPerson())} kcal',
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
