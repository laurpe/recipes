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

@DriftDatabase(tables: [Recipes, Ingredients])
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

  // RECIPES

  // Add a new recipe
  Future<int> addRecipe(Recipe recipe) {
    return into(recipes).insert(recipe.toCompanion());
  }

  // INGREDIENTS
  Future<void> addIngredients(
      List<Ingredient> ingredientList, int recipeId) async {
    await batch((batch) {
      batch.insertAll(
        ingredients,
        ingredientList.map((ingredient) => ingredient.toCompanion()).toList(),
      );
    });
  }
}
