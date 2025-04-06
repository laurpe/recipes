import 'package:drift/drift.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/grocery.dart';

part 'groceries_dao.g.dart';

@DriftAccessor(tables: [Groceries])
class GroceriesDao extends DatabaseAccessor<AppDatabase>
    with _$GroceriesDaoMixin {
  GroceriesDao(super.db);

  // Get groceries.
  Future<List<GroceryData>> getGroceries() async {
    return (select(groceries)
          ..orderBy([(g) => OrderingTerm(expression: g.listOrder)]))
        .get();
  }

  // Add a grocery.
  Future<int> addGrocery(Grocery grocery) async {
    return into(groceries).insert(grocery.toCompanion());
  }

  // Update a grocery.
  Future<void> updateGrocery(Grocery grocery) async {
    await (update(groceries)..where((g) => g.id.equals(grocery.id!)))
        .write(grocery.toCompanion());
  }

  // Delete a grocery.
  Future<void> deleteGrocery(int groceryId) async {
    await (delete(groceries)..where((g) => g.id.equals(groceryId))).go();
  }

  // Add or update groceries.
  Future<void> insertOrUpdateGroceries(List<Grocery> groceryList) async {
    await transaction(() async {
      for (final grocery in groceryList) {
        if (grocery.id == null) {
          await into(groceries).insert(grocery.toCompanion());
        } else {
          await (update(groceries)..where((g) => g.id.equals(grocery.id!)))
              .write(grocery.toCompanion());
        }
      }
    });
  }

  // Delete all groceries.
  Future<void> deleteGroceries() async {
    await delete(groceries).go();
  }

  Future<void> toggleGroceryBought(Grocery grocery) async {
    await (update(groceries)..where((g) => g.id.equals(grocery.id!)))
        .write(GroceriesCompanion(isBought: Value(!grocery.isBought)));
  }
}
