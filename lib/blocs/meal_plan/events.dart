import 'package:equatable/equatable.dart';

abstract class MealPlanEvent extends Equatable {
  const MealPlanEvent();

  @override
  get props => [];
}

class GetMealPlan extends MealPlanEvent {
  final int id;
  final String name;

  const GetMealPlan({required this.id, required this.name});

  @override
  get props => [id];
}
