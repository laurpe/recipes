import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/grocery.dart';
import 'package:recipes/models/recipe.dart';

/// Converts grocery units to default units.
Grocery unitsToDefaults(Grocery grocery) {
  switch (grocery.unit) {
    case 'tl':
      return grocery.copyWith(amount: grocery.amount * 5, unit: 'ml');
    case 'tsp':
      return grocery.copyWith(amount: grocery.amount * 5, unit: 'ml');
    case 'rkl':
      return grocery.copyWith(amount: grocery.amount * 15, unit: 'ml');
    case 'tbsp':
      return grocery.copyWith(amount: grocery.amount * 15, unit: 'ml');
    case 'cl':
      return grocery.copyWith(amount: grocery.amount * 10, unit: 'ml');
    case 'dl':
      return grocery.copyWith(amount: grocery.amount * 100, unit: 'ml');
    case 'l':
      return grocery.copyWith(amount: grocery.amount * 1000, unit: 'ml');
    case 'kg':
      return grocery.copyWith(amount: grocery.amount * 1000, unit: 'g');
    default:
      return grocery;
  }
}

/// Combines duplicate groceries by summing their amounts.
List<Grocery> combineDuplicateGroceries(List<Grocery> groceries) {
  Map<String, Grocery> resultMap =
      groceries.fold(<String, Grocery>{}, (accumulator, grocery) {
    if (accumulator.containsKey(grocery.name)) {
      accumulator[grocery.name] = Grocery(
          id: accumulator[grocery.name]!.id,
          name: grocery.name,
          amount: accumulator[grocery.name]!.amount + grocery.amount,
          unit: accumulator[grocery.name]!.unit,
          isBought: accumulator[grocery.name]!.isBought,
          listOrder: accumulator[grocery.name]!.listOrder);
      return accumulator;
    }
    accumulator[grocery.name] = grocery;
    return accumulator;
  });

  return resultMap.values.toList();
}

Future<void> addIngredientsToGroceries(Recipe recipe, int servings) async {
  final databaseClient = GetIt.I<DatabaseClient>();
  final groceries = await databaseClient.getGroceries();
  final ingredients = recipe.ingredients;
  final List<Grocery> newGroceries = [];
  final int timestamp = DateTime.now().millisecondsSinceEpoch;

  for (var ingredient in ingredients) {
    newGroceries.add(
      Grocery(
        name: ingredient.name,
        amount: ingredient.amountPerServing * servings,
        unit: ingredient.unit,
        isBought: false,
        listOrder: timestamp + ingredients.indexOf(ingredient),
      ),
    );
  }

  final allGroceries = groceries + newGroceries;

  List<Grocery> unitCorrectedGroceries = [];

  for (var grocery in allGroceries) {
    unitCorrectedGroceries.add(unitsToDefaults(grocery));
  }

  List<Grocery> combinedGroceries =
      combineDuplicateGroceries(unitCorrectedGroceries);

  try {
    databaseClient.insertOrUpdateGroceries(combinedGroceries);
  } catch (error) {
    rethrow;
  }
}
