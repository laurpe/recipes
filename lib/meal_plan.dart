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

  @override
  List<Object?> get props => [id, name];
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

  @override
  List<Object?> get props => [id, name, meals];
}

class Meal extends Equatable {
  final int? id;
  final String name;
  final int recipeId;
  final String recipeName;

  const Meal(
      {this.id,
      required this.name,
      required this.recipeId,
      required this.recipeName});

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
  List<Object?> get props => [id, name, recipeId, recipeName];
}
