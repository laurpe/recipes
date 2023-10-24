import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  get props => [];
}

class GetRecipe extends RecipeEvent {}
