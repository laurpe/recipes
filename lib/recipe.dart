import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final int? id;
  final String amount;
  final String name;

  const Ingredient({this.id, required this.amount, required this.name});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'amount': amount,
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  List<Object?> get props => [id, amount, name];
}

class Recipe extends Equatable {
  final int? id;
  final String name;
  final List<Ingredient> ingredients;
  final String instructions;

  const Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'instructions': instructions,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  List<Object?> get props => [id, name, ingredients, instructions];
}
