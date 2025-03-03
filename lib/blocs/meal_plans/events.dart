import 'package:equatable/equatable.dart';
import 'package:recipes/meal_plan.dart';

abstract class MealPlansEvent extends Equatable {
  const MealPlansEvent();

  @override
  get props => [];
}

class GetMealPlans extends MealPlansEvent {}

class MealPlanUpdated extends MealPlansEvent {
  final MealPlan mealPlan;

  const MealPlanUpdated({required this.mealPlan});
}

class MealPlanDeleted extends MealPlansEvent {
  final int mealPlanId;

  const MealPlanDeleted({required this.mealPlanId});
}
