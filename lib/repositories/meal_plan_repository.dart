import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/meal_plan.dart';

class MealPlanRepository {
  AppDatabase database = GetIt.I<AppDatabase>();

  MealPlanRepository();

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
}
