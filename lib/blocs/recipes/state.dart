import 'package:equatable/equatable.dart';
import 'package:recipes/models/recipe_list_item.dart';
import 'package:recipes/models/tag.dart';

sealed class RecipesState extends Equatable {
  const RecipesState();

  @override
  get props => [];
}

class LoadedRecipesState extends RecipesState {
  final List<RecipeListItem> recipes;
  final String? query;
  final int? offset;
  final List<Tag>? tags;
  final bool hasReachedEnd;
  final bool? favorites;

  const LoadedRecipesState({
    required this.recipes,
    required this.query,
    required this.offset,
    required this.tags,
    required this.hasReachedEnd,
    required this.favorites,
  });

  @override
  get props => [recipes, query, offset, tags, hasReachedEnd, favorites];
}

class LoadingRecipesState extends RecipesState {}

class ErrorLoadingRecipesState extends RecipesState {}
