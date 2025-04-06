import 'package:path_provider/path_provider.dart';
import 'package:recipes/data_mapper.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/meal_recipe.dart';
import 'package:recipes/models/recipe.dart';

import 'package:recipes/models/tag.dart';

class RecipeRepository {
  final AppDatabase database;

  RecipeRepository({required this.database});

  Future<Recipe> getRecipe(int id) async {
    final recipeData = await database.recipesDao.getRecipe(id);
    final ingredientsData =
        await database.ingredientsDao.getRecipeIngredients(id);
    final tagsData = await database.tagsDao.getRecipeTags(id);
    final imageData = await database.recipesDao.getRecipeImage(id);

    final directory = await getApplicationDocumentsDirectory();

    return DataMapper.recipeFromData(
        recipeData, ingredientsData, tagsData, imageData, directory.path);
  }

  Future<List<Recipe>> getRecipes() async {
    List<RecipeData> recipeData = await database.recipesDao.getRecipes();

    return DataMapper.recipesFromData(recipeData);
  }

  Future<int> addRecipe(Recipe recipe) {
    return database.recipesDao.addRecipe(recipe);
  }

  Future<void> updateRecipe(Recipe recipe) {
    return database.recipesDao.updateRecipe(recipe);
  }

  Future<void> deleteRecipe(int id) {
    return database.recipesDao.deleteRecipe(id);
  }

  Future<void> toggleFavoriteRecipe(Recipe recipe) {
    return database.recipesDao.toggleFavoriteRecipe(recipe);
  }

  // TODO: do searchRecipes parameters need to be required?
  Future<List<Recipe>> searchRecipes(
      {required int offset,
      required String query,
      required List<Tag> tags,
      required bool favorites}) {
    return database.recipesDao.searchRecipes(
        offset: offset, query: query, tags: tags, favorites: favorites);
  }

  Future<int> getRecipesCount() {
    return database.recipesDao.getRecipesCount();
  }

  Future<List<MealRecipe>> getRecipesById(Set<int> recipeIds) async {
    List<RecipeData> data = await database.recipesDao.getRecipesById(recipeIds);

    return DataMapper.mealRecipesFromData(data);
  }
}
