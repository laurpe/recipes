import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/tag.dart';

class Recipe extends Equatable {
  final int? id;
  final String name;
  final List<Ingredient>? ingredients;
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
    this.ingredients,
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

  RecipesCompanion toCompanion() {
    return RecipesCompanion(
        name: Value(name),
        instructions: Value(instructions),
        favorite: Value(favorite),
        servings: Value(servings),
        carbohydratesPerServing: Value(carbohydratesPerServing),
        proteinPerServing: Value(proteinPerServing),
        fatPerServing: Value(fatPerServing),
        caloriesPerServing: Value(caloriesPerServing));
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
        imagePath,
        carbohydratesPerServing,
        proteinPerServing,
        fatPerServing,
        caloriesPerServing
      ];
}
