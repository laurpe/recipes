import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:recipes/database.dart';

class MealPlan extends Equatable {
  final int? id;
  final String name;
  final int servingsPerMeal;
  final List<Day>? days;

  const MealPlan(
      {this.id,
      required this.name,
      required this.servingsPerMeal,
      required this.days});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'servingsPerMeal': servingsPerMeal,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  MealPlansCompanion toCompanion() {
    return MealPlansCompanion(
      name: Value(name),
      servingsPerMeal: Value(servingsPerMeal),
    );
  }

  MealPlan copyWith({
    int? id,
    String? name,
    int? servingsPerMeal,
    List<Day>? days,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      servingsPerMeal: servingsPerMeal ?? this.servingsPerMeal,
      days: days ?? this.days,
    );
  }

  @override
  List<Object?> get props => [id, name, servingsPerMeal, days];
}

class Day extends Equatable {
  final int? id;
  final String name;
  final List<Meal> meals;

  const Day({this.id, required this.name, required this.meals});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  DaysCompanion toCompanion(int mealPlanId) {
    return DaysCompanion(name: Value(name), mealPlanId: Value(mealPlanId));
  }

  Day copyWith({
    int? id,
    String? name,
    List<Meal>? meals,
  }) {
    return Day(
      id: id ?? this.id,
      name: name ?? this.name,
      meals: meals ?? this.meals,
    );
  }

  double getCarbsPerPerson() {
    return meals.fold(
        0.0, (sum, meal) => sum + (meal.carbohydratesPerServing ?? 0.0));
  }

  double getProteinPerPerson() {
    return meals.fold(
        0.0, (sum, meal) => sum + (meal.proteinPerServing ?? 0.0));
  }

  double getFatPerPerson() {
    return meals.fold(0.0, (sum, meal) => sum + (meal.fatPerServing ?? 0.0));
  }

  double getCaloriesPerPerson() {
    return meals.fold(
        0.0, (sum, meal) => sum + (meal.caloriesPerServing ?? 0.0));
  }

  @override
  List<Object?> get props => [id, name, meals];
}

class Meal extends Equatable {
  // TODO: should recipeId be here or passed separately?
  final int? id;
  final String name;
  final int? recipeId;
  final String? recipeName;
  final double? carbohydratesPerServing;
  final double? proteinPerServing;
  final double? fatPerServing;
  final double? caloriesPerServing;

  const Meal({
    this.id,
    required this.name,
    this.recipeId,
    this.recipeName,
    this.carbohydratesPerServing,
    this.proteinPerServing,
    this.fatPerServing,
    this.caloriesPerServing,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    if (recipeId != null) {
      map['recipe_id'] = recipeId;
    }

    return map;
  }

  MealsCompanion toCompanion(dayId) {
    return MealsCompanion(
      name: Value(name),
      dayId: Value(dayId),
    );
  }

  Meal copyWith({
    int? id,
    String? name,
    int? recipeId,
    String? recipeName,
    double? carbohydratesPerServing,
    double? proteinPerServing,
    double? fatPerServing,
    double? caloriesPerServing,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
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
        recipeId,
        recipeName,
        carbohydratesPerServing,
        proteinPerServing,
        fatPerServing,
        caloriesPerServing
      ];
}
