import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/meal_plans/bloc.dart';
import 'package:recipes/blocs/meal_plans/events.dart';
import 'package:recipes/blocs/meal_plans/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/screens/add_meal_plan.dart';
import 'package:recipes/screens/meal_plan.dart';

class MealPlanList extends StatelessWidget {
  const MealPlanList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          final databaseClient = GetIt.I<DatabaseClient>();
          return MealPlansBloc(databaseClient: databaseClient)
            ..add(GetMealPlans());
        },
        child: const MealPlansListView());
  }
}

class MealPlansListView extends StatelessWidget {
  const MealPlansListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealPlansBloc, MealPlansState>(
      builder: (context, state) {
        switch (state) {
          case LoadingMealPlansState():
            return const Center(child: CircularProgressIndicator());
          case ErrorLoadingMealPlansState():
            return const Center(child: Text('Error loading meal plans'));
          case LoadedMealPlansState():
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MealPlanFormView(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
              appBar: AppBar(
                title: const Text('Meal plans'),
              ),
              body: ListView.builder(
                itemCount: state.mealPlans.length,
                itemBuilder: (context, index) {
                  final mealPlan = state.mealPlans[index];
                  return Card(
                    child: ListTile(
                        title: Text(mealPlan.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MealPlan(id: mealPlan.id!),
                            ),
                          );
                        }),
                  );
                },
              ),
            );
        }
      },
    );
  }
}
