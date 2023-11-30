import 'package:equatable/equatable.dart';
import 'package:recipes/recipe.dart';

sealed class PaginatedRecipesState extends Equatable {
  const PaginatedRecipesState();

  @override
  get props => [];
}

class LoadedPaginatedRecipesState extends PaginatedRecipesState {
  final List<Recipe> recipes;
  final String? query;
  final int? offset;

  const LoadedPaginatedRecipesState({
    required this.recipes,
    required this.query,
    required this.offset,
  });

  @override
  get props => [recipes, query, offset];
}

class LoadingPaginatedRecipesState extends PaginatedRecipesState {}

class ErrorLoadingPaginatedRecipesState extends PaginatedRecipesState {}
