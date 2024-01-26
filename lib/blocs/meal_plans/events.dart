import 'package:equatable/equatable.dart';

abstract class MealPlansEvent extends Equatable {
  const MealPlansEvent();

  @override
  get props => [];
}

class GetMealPlans extends MealPlansEvent {}
