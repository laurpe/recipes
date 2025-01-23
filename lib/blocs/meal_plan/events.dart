import 'package:equatable/equatable.dart';

abstract class MealPlanEvent extends Equatable {
  const MealPlanEvent();

  @override
  get props => [];
}

class GetMealPlan extends MealPlanEvent {}
