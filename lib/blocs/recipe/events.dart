import 'package:equatable/equatable.dart';
import 'package:recipes/models/recipe.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  get props => [];
}

class GetRecipe extends RecipeEvent {}

class AddGroceries extends RecipeEvent {
  final List<Ingredient> ingredients;

  const AddGroceries({required this.ingredients});
}

class ToggleFavoriteRecipe extends RecipeEvent {
  const ToggleFavoriteRecipe();
}
