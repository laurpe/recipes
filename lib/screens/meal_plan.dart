import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/meal_plan/bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/database.dart';

class MealPlan extends StatelessWidget {
  final int id;
  final String name;

  const MealPlan({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          final databaseClient = GetIt.I<DatabaseClient>();
          return MealPlanBloc(databaseClient: databaseClient)
            ..add(GetMealPlan(id: id, name: name));
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
                title: Text(state.name),
              ),
              body: ListView.builder(
                itemCount: state.mealPlan.length,
                itemBuilder: (context, index) {
                  final day = state.mealPlan[index];
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
