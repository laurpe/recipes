import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/ingredient.dart';

class IngredientRepository {
  AppDatabase database = GetIt.I<AppDatabase>();

  IngredientRepository();

  Future<void> addIngredients(int recipeId, List<Ingredient> ingredientList) {
    return database.addIngredients(recipeId, ingredientList);
  }

  Future<void> updateRecipeIngredients(
      int recipeId, List<Ingredient> ingredientList) {
    return database.updateRecipeIngredients(recipeId, ingredientList);
  }

  // getRecipeIngredients needed??

  Future<void> deleteRecipeIngredients(int recipeId) {
    return database.deleteRecipeIngredients(recipeId);
  }
}
