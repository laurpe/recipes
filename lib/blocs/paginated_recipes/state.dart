import 'package:equatable/equatable.dart';
import 'package:recipes/recipe.dart';

sealed class PaginatedRecipesState extends Equatable {
  const PaginatedRecipesState();

  @override
  get props => [];
}

class LoadedPaginatedRecipesState extends PaginatedRecipesState {
  final List<Recipe> recipes;
  final bool hasReachedMax;

  const LoadedPaginatedRecipesState(
      {required this.recipes, required this.hasReachedMax});

  @override
  get props => [recipes, hasReachedMax];
}

class LoadingPaginatedRecipesState extends PaginatedRecipesState {}

class ErrorLoadingPaginatedRecipesState extends PaginatedRecipesState {}
