import 'package:get_it/get_it.dart';
import 'package:recipes/data_mapper.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/recipe.dart';

class RecipeRepository {
  AppDatabase database = GetIt.I<AppDatabase>();

  RecipeRepository();

  // TODO: handle imagePath
  Future<Recipe> getRecipe(int id) async {
    RecipeData recipeData = await database.getRecipeData(id);
    List<IngredientData> ingredientsData =
        await database.getRecipeIngredientsData(id);
    List<TagData> tagsData = await database.getRecipeTagsData(id);

    return DataMapper.recipeFromData(recipeData, ingredientsData, tagsData);
  }

  Future<List<Recipe>> getRecipesWithImage() async {
    List<RecipeData> recipeData = await database.getAllRecipes();
  }

  Future<int> addRecipe(Recipe recipe) {
    return database.addRecipe(recipe);
  }

  Future<void> updateRecipe(Recipe recipe) {
    return database.updateRecipe(recipe);
  }

  Future<void> deleteRecipe(int id) {
    return database.deleteRecipe(id);
  }

  Future<void> toggleFavorite(Recipe recipe) {
    return database.toggleFavoriteRecipe(recipe);
  }

  // TODO: do searchRecipes parameters need to be required?
  Future<List<Recipe>> search(
      {required int offset,
      required String query,
      required List<Tag> tags,
      required bool favorites}) {
    return database.searchRecipes(
        offset: offset, query: query, tags: tags, favorites: favorites);
  }
}
