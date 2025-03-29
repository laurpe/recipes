import 'package:recipes/data_mapper.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/meal_plan.dart';

class MealPlanRepository {
  final AppDatabase database;

  MealPlanRepository({required this.database});

  Future<int> addMeal(Meal meal, int dayId) async =>
      database.addMeal(meal, dayId);

  Future<int> updateMeal(Meal meal, int dayId) async =>
      database.updateMeal(meal, dayId);

  Future<int> addDay(Day day, int mealPlanId) async =>
      database.addDay(day, mealPlanId);

  Future<int> addMealPlan(MealPlan mealPlan) async =>
      database.addMealPlan(mealPlan);

  Future<void> updateMealPlan(MealPlan mealPlan) async =>
      database.updateMealPlan(mealPlan);

  Future<void> deleteMealPlan(int id) async => database.deleteMealPlan(id);

  Future<List<MealPlan>> getMealPlansList() async =>
      database.getMealPlansList();

  Future<MealPlan> getMealPlan(int id) async => database.getMealPlan(id);

  Future<Map<Ingredient, int>> getMealPlanIngredients(int mealPlanId) async {
    Map<IngredientData, int> data =
        await database.getMealPlanIngredients(mealPlanId);

    Map<Ingredient, int> result = {};

    for (var key in data.keys) {
      result[DataMapper.ingredientFromData(key)] = data[key]!;
    }

    return result;
  }
}
