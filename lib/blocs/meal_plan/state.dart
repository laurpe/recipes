import 'package:equatable/equatable.dart';
import 'package:recipes/meal_plan.dart';

sealed class MealPlanState extends Equatable {
  const MealPlanState();

  @override
  get props => [];
}

class LoadedMealPlanState extends MealPlanState {
  final List<Day> mealPlan;
  final String name;

  const LoadedMealPlanState({required this.mealPlan, required this.name});

  @override
  get props => [mealPlan];
}

class LoadingMealPlanState extends MealPlanState {}

class ErrorLoadingMealPlanState extends MealPlanState {}
