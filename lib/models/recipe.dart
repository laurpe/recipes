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
  final double? carbohydratesPerServing;
  final double? proteinPerServing;
  final double? fatPerServing;
  final double? caloriesPerServing;

  const Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.favorite,
    required this.servings,
    this.tags,
    this.imagePath,
    this.carbohydratesPerServing,
    this.proteinPerServing,
    this.fatPerServing,
    this.caloriesPerServing,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'instructions': instructions,
      'favorite': favorite ? 1 : 0,
      'servings': servings,
      'carbohydrates_per_serving': carbohydratesPerServing,
      'protein_per_serving': proteinPerServing,
      'fat_per_serving': fatPerServing,
      'calories_per_serving': caloriesPerServing,
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
    double? carbohydratesPerServing,
    double? proteinPerServing,
    double? fatPerServing,
    double? caloriesPerServing,
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
      carbohydratesPerServing:
          carbohydratesPerServing ?? this.carbohydratesPerServing,
      proteinPerServing: proteinPerServing ?? this.proteinPerServing,
      fatPerServing: fatPerServing ?? this.fatPerServing,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
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
        carbohydratesPerServing,
        proteinPerServing,
        fatPerServing,
        caloriesPerServing
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

class MealRecipe {
  final int recipeId;
  final String recipeName;
  final double? carbohydratesPerServing;
  final double? proteinPerServing;
  final double? fatPerServing;
  final double? caloriesPerServing;

  const MealRecipe(
      {required this.recipeId,
      required this.recipeName,
      this.carbohydratesPerServing,
      this.proteinPerServing,
      this.fatPerServing,
      this.caloriesPerServing});
}
