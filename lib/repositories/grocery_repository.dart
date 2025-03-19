import 'package:get_it/get_it.dart';
import 'package:recipes/data_mapper.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/grocery.dart';

class GroceryRepository {
  AppDatabase database = GetIt.I<AppDatabase>();

  GroceryRepository();

  Future<List<Grocery>> getAll() async {
    List<GroceryData> groceriesData = await database.getGroceries();

    return DataMapper.groceriesFromData(groceriesData);
  }

  Future<int> add(Grocery grocery) async => database.addGrocery(grocery);

  Future<void> update(Grocery grocery) async => database.updateGrocery(grocery);

  Future<void> delete(int id) async {
    return database.deleteGrocery(id);
  }

  Future<void> insertOrUpdate(List<Grocery> groceries) async =>
      database.insertOrUpdateGroceries(groceries);

  Future<void> deleteAll() async => database.deleteGroceries();

  Future<void> toggleBought(Grocery grocery) async =>
      database.toggleGroceryBought(grocery);
}
