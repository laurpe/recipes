import 'package:drift/drift.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/helpers/delete_image_from_disk.dart';
import 'package:recipes/models/recipe_detail.dart';
import 'package:recipes/models/recipe_list_item.dart';
import 'package:recipes/models/tag.dart';

part 'recipes_dao.g.dart';

@DriftAccessor(tables: [Recipes, RecipeImages])
class RecipesDao extends DatabaseAccessor<AppDatabase> with _$RecipesDaoMixin {
  RecipesDao(super.db);

  Future<RecipeData> getRecipe(int recipeId) async {
    return (select(recipes)..where((r) => r.id.equals(recipeId))).getSingle();
  }

  // Get basic recipe data for adding recipes to meal plan.
  // TODO: select only id and name columns?
  Future<List<RecipeData>> getRecipes() async {
    return select(recipes).get();
  }

  Future<int> addRecipe(RecipeDetail recipe) async {
    return into(recipes).insert(recipe.toCompanion());
  }

  // Update a recipe.
  Future<void> updateRecipe(RecipeDetail recipe) async {
    await (update(recipes)..where((r) => r.id.equals(recipe.id!)))
        .write(recipe.toCompanion());
  }

  // Delete a recipe, remove orphaned tasks and delete recipe image from disk.
  Future<void> deleteRecipe(int recipeId) async {
    // Fetch recipe image if it has one.
    final imageRow = await (select(recipeImages)
          ..where((i) => i.recipeId.equals(recipeId)))
        .getSingleOrNull();

    await transaction(() async {
      await (delete(recipes)..where((r) => r.id.equals(recipeId))).go();

      // Remove orphaned tags.
      await customStatement('''
        DELETE FROM tags 
        WHERE id NOT IN (
            SELECT DISTINCT tag_id FROM recipe_tags
        )
      ''');
    });

    // Delete image from disk.
    if (imageRow != null) {
      await deleteImageFromDisk(imageRow.path);
    }
  }

  // TODO: check where this is used, doesn't take the boolean anymore
  Future<void> toggleFavoriteRecipe(RecipeDetail recipe) async {
    await (update(recipes)..where((r) => r.id.equals(recipe.id!)))
        .write(RecipesCompanion(favorite: Value(!recipe.favorite)));
  }

  // Search recipes.
  // TODO: refactor + just give out recipedata
  Future<List<RecipeListItem>> searchRecipes({
    required int offset,
    required String query,
    required List<Tag> tags,
    required bool favorites,
  }) async {
    late final List<Map<String, dynamic>> recipeMaps;

    if (favorites) {
      if (tags.isNotEmpty) {
        final tagIds = tags.map((t) => t.id).join(',');
        final sql = '''
        SELECT recipes.* 
        FROM recipes 
        INNER JOIN recipe_tags ON recipes.id = recipe_tags.recipe_id 
        WHERE (recipe_tags.tag_id IN ($tagIds)
          AND recipes.name LIKE ?
          AND recipes.favorite = 1)
        GROUP BY recipes.id 
        HAVING COUNT(DISTINCT recipe_tags.tag_id) = ${tags.length} 
        LIMIT 15 OFFSET ?
      ''';
        final result = await customSelect(
          sql,
          variables: [
            Variable.withString('%$query%'),
            Variable.withInt(offset),
          ],
        ).get();
        recipeMaps = result.map((row) => row.data).toList();
      } else {
        final sql = '''
        SELECT * FROM recipes 
        WHERE name LIKE ? AND favorite = 1 
        LIMIT 15 OFFSET ?
      ''';
        final result = await customSelect(
          sql,
          variables: [
            Variable.withString('%$query%'),
            Variable.withInt(offset),
          ],
        ).get();
        recipeMaps = result.map((row) => row.data).toList();
      }
    } else if (tags.isNotEmpty) {
      final tagIds = tags.map((t) => t.id).join(',');
      final sql = '''
      SELECT recipes.* 
      FROM recipes 
      INNER JOIN recipe_tags ON recipes.id = recipe_tags.recipe_id 
      WHERE (recipe_tags.tag_id IN ($tagIds)
          AND recipes.name LIKE ?)
      GROUP BY recipes.id 
      HAVING COUNT(DISTINCT recipe_tags.tag_id) = ${tags.length} 
      LIMIT 15 OFFSET ?
    ''';
      final result = await customSelect(
        sql,
        variables: [
          Variable.withString('%$query%'),
          Variable.withInt(offset),
        ],
      ).get();
      recipeMaps = result.map((row) => row.data).toList();
    } else {
      final sql = '''
      SELECT * FROM recipes 
      WHERE name LIKE ? 
      LIMIT 15 OFFSET ?
    ''';
      final result = await customSelect(
        sql,
        variables: [
          Variable.withString('%$query%'),
          Variable.withInt(offset),
        ],
      ).get();
      recipeMaps = result.map((row) => row.data).toList();
    }

    List<RecipeListItem> recipeList = [];
    for (final recipe in recipeMaps) {
      recipeList.add(
        RecipeListItem(
          id: recipe['id'],
          name: recipe['name'],
          favorite: recipe['favorite'] == 1 ? true : false,
        ),
      );
    }

    return recipeList;
  }

  // Get recipe count.
  Future<int> getRecipesCount() async {
    final query = selectOnly(recipes)..addColumns([recipes.id.count()]);
    final row = await query.getSingle();
    return row.read(recipes.id.count()) ?? 0;
  }

  // Add image to recipe or update it.
  Future<void> insertOrUpdateRecipeImage(int recipeId, String path) async {
    final imageData = await (select(recipeImages)
          ..where((ri) => ri.recipeId.equals(recipeId)))
        .getSingleOrNull();

    if (imageData != null) {
      await (update(recipeImages)
            ..where((ri) => ri.path.equals(imageData.path)))
          .write(RecipeImagesCompanion(
        path: Value(path),
      ));
    } else {
      await into(recipeImages).insert(
        RecipeImagesCompanion.insert(
          recipeId: recipeId,
          path: path,
        ),
      );
    }
  }

  Future<RecipeImageData?> getRecipeImage(int recipeId) {
    return (select(recipeImages)..where((ri) => ri.recipeId.equals(recipeId)))
        .getSingleOrNull();
  }

  // Delete recipe image from recipeImages table.
  // TODO: handle situation where there is no image
  Future<void> deleteRecipeImage(int recipeId) async {
    await (delete(recipeImages)..where((ri) => ri.recipeId.equals(recipeId)))
        .go();
  }

  // Get a recipe detail for a set of recipes.
  Future<List<RecipeData>> getRecipesById(Set<int> recipeIds) async {
    return (select(recipes)..where((r) => r.id.isIn(recipeIds.toList()))).get();
  }
}
