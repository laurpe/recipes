import 'package:equatable/equatable.dart';
import 'package:recipes/recipe.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  get props => [];
}

class GetRecipes extends RecipesEvent {
  final int? offset;
  final String? query;
  final List<Tag>? tags;
  final bool? favorites;

  const GetRecipes({this.offset, this.query, this.tags, this.favorites});
}

class RecipeUpdated extends RecipesEvent {
  final Recipe recipe;

  const RecipeUpdated({required this.recipe});
}

class RecipeDeleted extends RecipesEvent {
  final int recipeId;

  const RecipeDeleted({required this.recipeId});
}
