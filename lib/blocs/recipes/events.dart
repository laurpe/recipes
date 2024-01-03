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

  const GetRecipes({this.offset, this.query});
}

class ToggleFavoriteRecipe extends RecipesEvent {
  final Recipe recipe;

  const ToggleFavoriteRecipe({required this.recipe});
}

class RecipeUpdated extends RecipesEvent {
  final Recipe recipe;

  const RecipeUpdated({required this.recipe});
}
