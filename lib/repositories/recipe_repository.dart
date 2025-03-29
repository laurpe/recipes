import 'package:path_provider/path_provider.dart';
import 'package:recipes/data_mapper.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/meal_recipe.dart';
import 'package:recipes/models/recipe_detail.dart';
import 'package:recipes/models/recipe_list_item.dart';
import 'package:recipes/models/tag.dart';

class RecipeRepository {
  final AppDatabase database;

  RecipeRepository({required this.database});

  Future<RecipeDetail> getRecipe(int id) async {
    final recipeData = await database.getRecipe(id);
    final ingredientsData = await database.getRecipeIngredients(id);
    final tagsData = await database.getRecipeTags(id);
    final imageData = await database.getRecipeImage(id);

    final directory = await getApplicationDocumentsDirectory();

    return DataMapper.recipeFromData(
        recipeData, ingredientsData, tagsData, imageData, directory.path);
  }

  Future<List<RecipeListItem>> getRecipes() async {
    List<RecipeData> recipeData = await database.getRecipes();

    return DataMapper.recipesFromData(recipeData);
  }

  Future<int> addRecipe(RecipeDetail recipe) {
    return database.addRecipe(recipe);
  }

  Future<void> updateRecipe(RecipeDetail recipe) {
    return database.updateRecipe(recipe);
  }

  Future<void> deleteRecipe(int id) {
    return database.deleteRecipe(id);
  }

  Future<void> toggleFavoriteRecipe(RecipeDetail recipe) {
    return database.toggleFavoriteRecipe(recipe);
  }

  // TODO: do searchRecipes parameters need to be required?
  Future<List<RecipeListItem>> searchRecipes(
      {required int offset,
      required String query,
      required List<Tag> tags,
      required bool favorites}) {
    return database.searchRecipes(
        offset: offset, query: query, tags: tags, favorites: favorites);
  }

  Future<int> getRecipesCount() {
    return database.getRecipesCount();
  }

  Future<List<MealRecipe>> getRecipesById(Set<int> recipeIds) async {
    List<RecipeData> data = await database.getRecipesById(recipeIds);

    return DataMapper.mealRecipesFromData(data);
  }
}
