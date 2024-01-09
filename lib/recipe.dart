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

class Tag extends Equatable {
  final int? id;
  final String name;

  const Tag({this.id, required this.name});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  List<Object?> get props => [id, name];
}

class Recipe extends Equatable {
  final int? id;
  final String name;
  final List<Ingredient> ingredients;
  final String instructions;
  final bool favorite;
  final int servings;
  final List<Tag>? tags;

  const Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.favorite,
    required this.servings,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'instructions': instructions,
      'favorite': favorite,
      'servings': servings,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  List<Object?> get props =>
      [id, name, ingredients, instructions, favorite, servings, tags];
}
