import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final int? id;
  final String amount;
  final String unit;
  final String name;

  const Ingredient(
      {this.id, required this.amount, required this.unit, required this.name});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'amount': amount,
      'unit': unit,
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  List<Object?> get props => [id, amount, unit, name];
}

class Recipe extends Equatable {
  final int? id;
  final String name;
  final List<Ingredient> ingredients;
  final String instructions;
  final bool favorite;

  const Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.favorite,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'instructions': instructions,
      'favorite': favorite,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  List<Object?> get props => [id, name, ingredients, instructions, favorite];
}
