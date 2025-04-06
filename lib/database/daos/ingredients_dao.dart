import 'package:drift/drift.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/ingredient.dart';

part 'ingredients_dao.g.dart';

@DriftAccessor(tables: [Ingredients])
class IngredientsDao extends DatabaseAccessor<AppDatabase>
    with _$IngredientsDaoMixin {
  IngredientsDao(super.db);

  // Add a list of ingredients to a recipe.
  Future<void> addIngredients(
      int recipeId, List<Ingredient> ingredientList) async {
    await batch((batch) {
      batch.insertAll(
        ingredients,
        ingredientList
            .map((ingredient) => ingredient.toCompanion(recipeId))
            .toList(),
      );
    });
  }

  // Update a recipe's ingredients.
  // TODO: actually update instead of deleting and adding again
  Future<void> updateRecipeIngredients(
      int recipeId, List<Ingredient> ingredientList) async {
    await deleteRecipeIngredients(recipeId);
    await addIngredients(recipeId, ingredientList);
  }

  // Get a recipe's ingredients.
  Future<List<IngredientData>> getRecipeIngredients(int recipeId) async {
    return (select(ingredients)..where((i) => i.recipeId.equals(recipeId)))
        .get();
  }

  // Delete a recipe's ingredients.
  Future<void> deleteRecipeIngredients(int recipeId) async {
    await (delete(ingredients)..where((i) => i.recipeId.equals(recipeId))).go();
  }
}
