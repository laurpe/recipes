import 'package:equatable/equatable.dart';
import 'package:recipes/recipe.dart';

sealed class RecipesState extends Equatable {
  const RecipesState();

  @override
  get props => [];
}

class LoadedRecipesState extends RecipesState {
  final List<Recipe> recipes;
  final String? query;
  final int? offset;

  const LoadedRecipesState({
    required this.recipes,
    required this.query,
    required this.offset,
  });

  @override
  get props => [recipes, query, offset];
}

class LoadingRecipesState extends RecipesState {}

class ErrorLoadingRecipesState extends RecipesState {}
