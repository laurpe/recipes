import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

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
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'recipes_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
