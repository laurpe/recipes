import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/meal_plan/bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/meal_plan.dart';
import 'package:recipes/screens/edit_meal_plan.dart';

// TODO: make this and recipe result use same class
sealed class Result<T> {
  final T? data;

  Result(this.data);
}

class Updated extends Result<MealPlan> {
  Updated(MealPlan data) : super(data);
}

class Deleted extends Result<int> {
  Deleted(int data) : super(data);
}

class Added extends Result<MealPlan> {
  Added(MealPlan data) : super(data);
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
                          await GetIt.I<DatabaseClient>()
                              .deleteMealPlan(state.mealPlan.id!);
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
              body: ListView.builder(
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
            );
        }
      },
    );
  }
}
