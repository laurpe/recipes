import 'package:recipes/data_mapper.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/grocery.dart';

class GroceryRepository {
  final AppDatabase database;

  GroceryRepository({required this.database});

  Future<List<Grocery>> getGroceries() async {
    List<GroceryData> groceriesData =
        await database.groceriesDao.getGroceries();

    return DataMapper.groceriesFromData(groceriesData);
  }

  Future<int> addGrocery(Grocery grocery) async =>
      database.groceriesDao.addGrocery(grocery);

  Future<void> updateGrocery(Grocery grocery) async =>
      database.groceriesDao.updateGrocery(grocery);

  Future<void> deleteGrocery(int id) async {
    return database.groceriesDao.deleteGrocery(id);
  }

  Future<void> insertOrUpdateGroceries(List<Grocery> groceries) async =>
      database.groceriesDao.insertOrUpdateGroceries(groceries);

  Future<void> deleteGroceries() async =>
      database.groceriesDao.deleteGroceries();

  Future<void> toggleGroceryBought(Grocery grocery) async =>
      database.groceriesDao.toggleGroceryBought(grocery);
}
