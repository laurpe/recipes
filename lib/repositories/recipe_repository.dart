import 'package:get_it/get_it.dart';
import 'package:recipes/data_mapper.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/recipe_detail.dart';
import 'package:recipes/models/recipe_list_item.dart';
import 'package:recipes/models/tag.dart';

class RecipeRepository {
  AppDatabase database = GetIt.I<AppDatabase>();

  RecipeRepository();

  Future<RecipeDetail> getRecipe(int id) async {
    RecipeData recipeData = await database.getRecipe(id);
    List<IngredientData> ingredientsData =
        await database.getRecipeIngredients(id);
    List<TagData> tagsData = await database.getRecipeTags(id);
    RecipeImageData? imageData = await database.getRecipeImage(id);

    return DataMapper.recipeFromData(
        recipeData, ingredientsData, tagsData, imageData);
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

  Future<void> toggleFavorite(RecipeDetail recipe) {
    return database.toggleFavoriteRecipe(recipe);
  }

  // TODO: do searchRecipes parameters need to be required?
  Future<List<RecipeListItem>> search(
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
}
