import 'package:equatable/equatable.dart';

class MealPlan extends Equatable {
  final int? id;
  final String name;
  final List<Day>? days;

  const MealPlan({this.id, required this.name, required this.days});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  MealPlan copyWith({
    int? id,
    String? name,
    List<Day>? days,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
    );
  }

  @override
  List<Object?> get props => [id, name, days];
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

  @override
  List<Object?> get props => [id, name, meals];
}

class Meal extends Equatable {
  final int? id;
  final String name;
  final int? recipeId;
  final String? recipeName;

  const Meal({this.id, required this.name, this.recipeId, this.recipeName});

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

  Meal copyWith({
    int? id,
    String? name,
    int? recipeId,
    String? recipeName,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
    );
  }

  @override
  List<Object?> get props => [id, name, recipeId, recipeName];
}
