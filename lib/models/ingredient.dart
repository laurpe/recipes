import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:recipes/database.dart';

class Ingredient extends Equatable {
  final int? id;
  final double amountPerServing;
  final String unit;
  final String name;

  const Ingredient(
      {this.id,
      required this.amountPerServing,
      required this.unit,
      required this.name});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'amount_per_serving': amountPerServing,
      'unit': unit,
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  IngredientsCompanion toCompanion(int recipeId) {
    return IngredientsCompanion(
        name: Value(name),
        amountPerServing: Value(amountPerServing),
        unit: Value(unit),
        recipeId: Value(recipeId));
  }

  @override
  List<Object?> get props => [id, amountPerServing, unit, name];
}
