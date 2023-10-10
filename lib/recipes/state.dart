import 'package:equatable/equatable.dart';
import 'package:recipes/recipe.dart';

sealed class RecipesState extends Equatable {
  const RecipesState();

  @override
  get props => [];
}

class LoadedRecipesState extends RecipesState {
  final List<Recipe> recipes;

  const LoadedRecipesState({required this.recipes});

  @override
  get props => [recipes];
}

class LoadingRecipesState extends RecipesState {}

class ErrorLoadingRecipesState extends RecipesState {}
