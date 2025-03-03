import 'package:equatable/equatable.dart';
import 'package:recipes/meal_plan.dart';

sealed class MealPlansState extends Equatable {
  const MealPlansState();

  @override
  get props => [];
}

class LoadedMealPlansState extends MealPlansState {
  final List<MealPlan> mealPlans;

  const LoadedMealPlansState({required this.mealPlans});

  @override
  get props => [mealPlans];
}

class LoadingMealPlansState extends MealPlansState {}

class ErrorLoadingMealPlansState extends MealPlansState {}
