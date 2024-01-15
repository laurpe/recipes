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
  final List<Tag>? tags;

  const LoadedRecipesState({
    required this.recipes,
    required this.query,
    required this.offset,
    required this.tags,
  });

  @override
  get props => [recipes, query, offset, tags];
}

class LoadingRecipesState extends RecipesState {}

class ErrorLoadingRecipesState extends RecipesState {}
