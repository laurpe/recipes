import 'package:recipes/grocery.dart';
import 'package:recipes/helpers/add_ingredients_to_groceries.dart';
import 'package:test/test.dart';

void main() {
  test('grocery units are converted to defaults correctly', () {
    final groceryKg = Grocery(
        amount: 1, unit: 'kg', name: 'flour', isBought: false, listOrder: 1);

    final convertedGroceryKg = unitsToDefaults(groceryKg);

    expect(convertedGroceryKg.amount, 1000);
    expect(convertedGroceryKg.unit, 'g');

    final groceryTsp = Grocery(
        amount: 2.5, unit: 'tsp', name: 'salt', isBought: false, listOrder: 1);

    final convertedGroceryTsp = unitsToDefaults(groceryTsp);

    expect(convertedGroceryTsp.amount, 12.5);
    expect(convertedGroceryTsp.unit, 'ml');

    final groceryTbsp = Grocery(
        amount: 2, unit: 'tbsp', name: 'sugar', isBought: false, listOrder: 1);

    final convertedGroceryTbsp = unitsToDefaults(groceryTbsp);

    expect(convertedGroceryTbsp.amount, 30);
    expect(convertedGroceryTbsp.unit, 'ml');

    final groceryDl = Grocery(
        amount: 5.25, unit: 'dl', name: 'milk', isBought: false, listOrder: 1);

    final convertedGroceryDl = unitsToDefaults(groceryDl);

    expect(convertedGroceryDl.amount, 525);
    expect(convertedGroceryDl.unit, 'ml');

    final groceryLitre = Grocery(
        amount: 3.75, unit: 'l', name: 'water', isBought: false, listOrder: 1);

    final convertedGroceryLitre = unitsToDefaults(groceryLitre);

    expect(convertedGroceryLitre.amount, 3750);
    expect(convertedGroceryLitre.unit, 'ml');
  });

  test('grocery amounts are combined correctly', () {
    final groceries = [
      Grocery(
          amount: 300,
          unit: 'ml',
          name: 'flour',
          isBought: false,
          listOrder: 1),
      Grocery(
          amount: 5, unit: 'ml', name: 'salt', isBought: false, listOrder: 2),
      Grocery(
          amount: 250,
          unit: 'ml',
          name: 'flour',
          isBought: false,
          listOrder: 3),
      Grocery(
          amount: 7.5, unit: 'ml', name: 'salt', isBought: false, listOrder: 4),
    ];

    final combinedGroceries = combineDuplicateGroceries(groceries);

    expect(combinedGroceries.length, 2);
    expect(combinedGroceries[0].amount, 550);
    expect(combinedGroceries[0].name, 'flour');
    expect(combinedGroceries[1].amount, 12.5);
    expect(combinedGroceries[1].name, 'salt');
  });
}
