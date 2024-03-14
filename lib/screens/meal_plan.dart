import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/meal_plan/bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/screens/edit_meal_plan.dart';

class MealPlan extends StatelessWidget {
  final int id;

  const MealPlan({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          final databaseClient = GetIt.I<DatabaseClient>();
          return MealPlanBloc(databaseClient: databaseClient)
            ..add(GetMealPlan(id: id));
        },
        child: const MealPlanView());
  }
}

class MealPlanView extends StatelessWidget {
  const MealPlanView({
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditMealPlan(id: state.mealPlan.id!),
                            ),
                          );
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
