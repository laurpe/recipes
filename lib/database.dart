import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
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
  IntColumn get recipeId => integer().references(Recipes, #id)();
}

@DataClassName('TagData')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('RecipeTagData')
class RecipeTags extends Table {
  IntColumn get recipeId => integer().references(Recipes, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

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

  // Add a new recipe.
  Future<int> addRecipe(Recipe recipe) {
    return into(recipes).insert(recipe.toCompanion());
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
