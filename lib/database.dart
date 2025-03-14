import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

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

@DriftDatabase(tables: [Recipes])
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
    return into(recipes).insert(recipe);
  }

  // Update a recipe
}
