import 'package:recipes/data_mapper.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/grocery.dart';

class GroceryRepository {
  final AppDatabase database;

  GroceryRepository({required this.database});

  Future<List<Grocery>> getGroceries() async {
    List<GroceryData> groceriesData = await database.getGroceries();

    return DataMapper.groceriesFromData(groceriesData);
  }

  Future<int> addGrocery(Grocery grocery) async => database.addGrocery(grocery);

  Future<void> updateGrocery(Grocery grocery) async =>
      database.updateGrocery(grocery);

  Future<void> deleteGrocery(int id) async {
    return database.deleteGrocery(id);
  }

  Future<void> insertOrUpdateGroceries(List<Grocery> groceries) async =>
      database.insertOrUpdateGroceries(groceries);

  Future<void> deleteGroceries() async => database.deleteGroceries();

  Future<void> toggleGroceryBought(Grocery grocery) async =>
      database.toggleGroceryBought(grocery);
}
