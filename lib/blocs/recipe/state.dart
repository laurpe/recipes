import 'package:equatable/equatable.dart';
import 'package:recipes/models/recipe.dart';

sealed class RecipeState extends Equatable {
  const RecipeState();

  @override
  get props => [];
}

class LoadedRecipeState extends RecipeState {
  final Recipe recipe;

  const LoadedRecipeState({required this.recipe});

  @override
  get props => [recipe];
}

class LoadingRecipeState extends RecipeState {}

class ErrorLoadingRecipeState extends RecipeState {}
