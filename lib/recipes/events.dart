import 'package:equatable/equatable.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  get props => [];
}

class GetRecipes extends RecipesEvent {}
