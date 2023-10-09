import 'package:equatable/equatable.dart';
import 'package:recipes/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  get props => [];
}

class LoadedRecipesState extends RecipeState {
  final List<Recipe> recipes;

  const LoadedRecipesState({required this.recipes});

  @override
  get props => [recipes];
}

class LoadingRecipesState extends RecipeState {}

class ErrorLoadingRecipesState extends RecipeState {}
