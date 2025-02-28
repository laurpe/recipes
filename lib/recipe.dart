import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [id, amountPerServing, unit, name];
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

  Tag copyWith({
    int? id,
    String? name,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
    );
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
  final String? imagePath;
  final double? carbohydrates;
  final double? protein;
  final double? fat;
  final double? calories;

  const Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.favorite,
    required this.servings,
    this.tags,
    this.imagePath,
    this.carbohydrates,
    this.protein,
    this.fat,
    this.calories,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'instructions': instructions,
      'favorite': favorite ? 1 : 0,
      'servings': servings,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'fat': fat,
      'calories': calories,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  Recipe copyWith({
    int? id,
    String? name,
    List<Ingredient>? ingredients,
    String? instructions,
    bool? favorite,
    int? servings,
    List<Tag>? tags,
    String? imagePath,
    double? carbohydrates,
    double? protein,
    double? fat,
    double? calories,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      favorite: favorite ?? this.favorite,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      imagePath: imagePath ?? this.imagePath,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      calories: calories ?? this.calories,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        ingredients,
        instructions,
        favorite,
        servings,
        tags,
        carbohydrates,
        protein,
        fat,
        calories
      ];
}

class RecipeListItem extends Equatable {
  final int id;
  final String name;

  const RecipeListItem({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
