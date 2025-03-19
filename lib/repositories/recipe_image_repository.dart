import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/widgets/recipe_form.dart';

class RecipeImageRepository {
  AppDatabase database = GetIt.I<AppDatabase>();

  RecipeImageRepository();

  Future<void> insertOrUpdateImage(int recipeId, String path) {
    return database.insertOrUpdateRecipeImage(recipeId, path);
  }

  Future<void> deleteImage(int recipeId, String path) async {
    await database.deleteRecipeImage(recipeId);

    await deleteImageFromDisk(path);
  }
}
