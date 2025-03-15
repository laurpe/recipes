import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipes/models/recipe.dart';

part 'database.g.dart';

@DataClassName('RecipeData')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get instructions => text()();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  IntColumn get servings => integer()();
  RealColumn get carbohydratesPerServing => real().nullable()();
  RealColumn get proteinPerServing => real().nullable()();
  RealColumn get fatPerServing => real().nullable()();
  RealColumn get caloriesPerServing => real().nullable()();
}

@DataClassName('IngredientData')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get amountPerServing => real()();
  TextColumn get unit => text()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
}

@DataClassName('TagData')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('RecipeTagData')
class RecipeTags extends Table {
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {recipeId, tagId};
}

@DriftDatabase(tables: [Recipes, Ingredients, Tags, RecipeTags])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'recipes_db',
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }

  // RECIPES -----------------------------------

  // Get recipe.
  Future<Recipe> getRecipe(int recipeId) async {
    final recipeData = await (select(recipes)
          ..where((tbl) => tbl.id.equals(recipeId)))
        .getSingle();

    // TODO: add image path

    // final imageData = await (select(recipeImages)
    //       ..where((tbl) => tbl.recipeId.equals(recipeId)))
    //     .getSingleOrNull();

    // final directory = await getApplicationDocumentsDirectory();

    return Recipe(
      id: recipeData.id,
      name: recipeData.name,
      instructions: recipeData.instructions,
      ingredients: await getRecipeIngredients(recipeData.id),
      favorite: recipeData.favorite,
      servings: recipeData.servings,
      tags: await getRecipeTags(recipeData.id),
      // imagePath: imageData != null
      //     ? '${directory.path}/images/${imageData.name}'
      //     : null,
      carbohydratesPerServing: recipeData.carbohydratesPerServing,
      proteinPerServing: recipeData.proteinPerServing,
      fatPerServing: recipeData.fatPerServing,
      caloriesPerServing: recipeData.caloriesPerServing,
    );
  }

  // Add a new recipe.
  // Tags and image are added separately.
  // TODO: add ingredients separately
  Future<int> addRecipe(Recipe recipe) async {
    int recipeId = await into(recipes).insert(recipe.toCompanion());

    await addIngredients(recipeId, recipe.ingredients);

    return recipeId;
  }

  // Update a recipe.
  Future<void> updateRecipe(Recipe recipe) async {
    // Delete recipe's old ingredients.
    deleteRecipeIngredients(recipe.id!);

    // Add new ingredients.
    addIngredients(recipe.id!, recipe.ingredients);

    // Update the recipe record in the recipes table.
    await (update(recipes)..where((r) => r.id.equals(recipe.id!)))
        .write(recipe.toCompanion());
  }

  Future<void> deleteRecipe(int recipeId) async {
    //TODO: handle images

    // final directory = await getApplicationDocumentsDirectory();

    // final imageRow = await (select(recipeImages)
    //       ..where((tbl) => tbl.recipeId.equals(recipeId)))
    //     .getSingleOrNull();

    // if (imageRow != null) {
    //   final file = File('${directory.path}/images/${imageRow.name}');
    //   await file.delete();
    // }

    await transaction(() async {
      await (delete(recipes)..where((tbl) => tbl.id.equals(recipeId))).go();

      // TODO: tags should be unique and shared
      await customStatement('''
      DELETE FROM tags 
      WHERE id NOT IN (
          SELECT DISTINCT tag_id FROM recipe_tags
      )
    ''');
    });
  }

  Future<void> toggleFavoriteRecipe(Recipe recipe) async {
    await (update(recipes)..where((r) => r.id.equals(recipe.id!)))
        .write(RecipesCompanion(favorite: Value(!recipe.favorite)));
  }

  // Search recipes.
  // TODO: refactor
  Future<List<Recipe>> searchRecipes({
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

    List<Recipe> recipeList = [];
    for (final recipe in recipeMaps) {
      recipeList.add(
        Recipe(
          id: recipe['id'],
          name: recipe['name'],
          instructions: recipe['instructions'],
          ingredients: await getRecipeIngredients(recipe['id']),
          favorite: recipe['favorite'] == 1 ? true : false,
          servings: recipe['servings'],
          tags: await getRecipeTags(recipe['id']),
          // TODO: add imagePath
          // imagePath: null,
          carbohydratesPerServing: recipe['carbohydratesPerServing'],
          proteinPerServing: recipe['proteinPerServing'],
          fatPerServing: recipe['fatPerServing'],
          caloriesPerServing: recipe['caloriesPerServing'],
        ),
      );
    }

    return recipeList;
  }

  // INGREDIENTS --------------------------------

  // Add a list of ingredients to a recipe.
  Future<void> addIngredients(
      int recipeId, List<Ingredient> ingredientList) async {
    await batch((batch) {
      batch.insertAll(
        ingredients,
        ingredientList.map((ingredient) => ingredient.toCompanion()).toList(),
      );
    });
  }

  // Get a recipe's ingredients.
  Future<List<Ingredient>> getRecipeIngredients(int recipeId) async {
    List<IngredientData> ingredientList = await (select(ingredients)
          ..where((i) => i.recipeId.equals(recipeId)))
        .get();

    return ingredientList
        .map((i) => Ingredient(
            id: i.id,
            name: i.name,
            amountPerServing: i.amountPerServing,
            unit: i.unit))
        .toList();
  }

  // Delete a recipe's ingredients.
  Future<void> deleteRecipeIngredients(int recipeId) async {
    await (delete(ingredients)..where((i) => i.recipeId.equals(recipeId))).go();
  }

  // TAGS ---------------------------------------

  // Get all tags.
  Future<List<Tag>> getTags() async {
    List<TagData> tagList = await select(tags).get();
    return tagList.map((tag) => Tag(id: tag.id, name: tag.name)).toList();
  }

  // Add a list of tags and return their ids.
  // Can't use batch because it returns void.
  Future<List<int>> addTags(List<Tag> tagList) async {
    List<int> ids = [];

    for (var tag in tagList) {
      int id = await into(tags).insert(tag.toCompanion());

      ids.add(id);
    }

    return ids;
  }

// Get a recipe's tags.
  Future<List<Tag>> getRecipeTags(int recipeId) async {
    final query = select(recipeTags).join([
      innerJoin(tags, tags.id.equalsExp(recipeTags.tagId)),
    ])
      ..where(recipeTags.recipeId.equals(recipeId));

    final rows = await query.get();
    return rows.map((row) {
      final tagData = row.readTable(tags);
      return Tag(
        id: tagData.id,
        name: tagData.name,
      );
    }).toList();
  }

  // Add tags to a recipe.
  Future<void> addRecipeTags(int recipeId, List<int> tagIds) async {
    await batch((batch) {
      batch.insertAll(
        recipeTags,
        tagIds
            .map((tagId) =>
                RecipeTagsCompanion.insert(recipeId: recipeId, tagId: tagId))
            .toList(),
      );
    });
  }

  // Update a recipe's tags (delete old ones and add new ones).
  Future<void> updateRecipeTags(int recipeId, List<int> tagIds) async {
    await deleteRecipeTags(recipeId);
    await addRecipeTags(recipeId, tagIds);
  }

  // Delete recipe's tags.
  Future<void> deleteRecipeTags(int recipeId) async {
    await (delete(recipeTags)..where((t) => t.recipeId.equals(recipeId))).go();
  }
}
