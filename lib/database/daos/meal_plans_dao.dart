import 'package:drift/drift.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/meal_plan.dart';

part 'meal_plans_dao.g.dart';

@DriftAccessor(tables: [MealPlans, Days, Meals, Ingredients])
class MealPlansDao extends DatabaseAccessor<AppDatabase>
    with _$MealPlansDaoMixin {
  MealPlansDao(super.db);

  // Add a meal.
  Future<int> addMeal(Meal meal, int dayId) async {
    return into(meals).insert(meal.toCompanion(dayId));
  }

  Future<int> updateMeal(Meal meal, int dayId) async {
    return (update(meals)..where((m) => m.id.equals(meal.id!)))
        .write(meal.toCompanion(dayId));
  }

  // Add a day.
  Future<int> addDay(Day day, int mealPlanId) async {
    return await into(days).insert(day.toCompanion(mealPlanId));
  }

  // Update a day.
  Future<int> updateDay(Day day, int mealPlanId) async {
    return (update(days)..where((d) => d.id.equals(day.id!)))
        .write(day.toCompanion(mealPlanId));
  }

  // Add a meal plan.
  Future<int> addMealPlan(MealPlan mealPlan) async {
    final mealPlanId = await into(mealPlans).insert(mealPlan.toCompanion());

    for (final day in mealPlan.days!) {
      final dayId = await addDay(day, mealPlanId);
      for (final meal in day.meals) {
        await addMeal(meal, dayId);
      }
    }

    return mealPlanId;
  }

  // Update a meal plan.
  Future<void> updateMealPlan(MealPlan mealPlan) async {
    await (update(mealPlans)..where((m) => m.id.equals(mealPlan.id!)))
        .write(mealPlan.toCompanion());

    for (final day in mealPlan.days!) {
      await updateDay(day, mealPlan.id!);
      for (final meal in day.meals) {
        await updateMeal(meal, day.id!);
      }
    }
  }

  // Delete a meal plan.
  Future<void> deleteMealPlan(int mealPlanId) async {
    await (delete(mealPlans)..where((m) => m.id.equals(mealPlanId))).go();
  }

  // Get list of meal plans.
  Future<List<MealPlan>> getMealPlansList() async {
    final mealPlanDataList = await select(mealPlans).get();

    return mealPlanDataList
        .map((data) => MealPlan(
              id: data.id,
              name: data.name,
              servingsPerMeal: data.servingsPerMeal,
              days: null,
            ))
        .toList();
  }

  Future<MealPlan> getMealPlan(int mealPlanId) async {
    // Fetch the meal plan row.
    final mealPlanData = await (select(mealPlans)
          ..where((m) => m.id.equals(mealPlanId)))
        .getSingle();

    // Fetch the days belonging to this meal plan.
    final dayList = await (select(days)
          ..where((d) => d.mealPlanId.equals(mealPlanId)))
        .get();

    // Get the IDs of all days.
    final dayIds = dayList.map((d) => d.id).toList();

    // Fetch the meals for these days.
    final mealDataList =
        await (select(meals)..where((m) => m.dayId.isIn(dayIds))).get();

    // Collect the unique recipe IDs from the meals.
    final recipeIds = mealDataList.map((m) => m.recipeId).toSet();
    // TODO: combine all meal plan data in bloc
    final mealRecipes = await db.recipesDao.getRecipesById(recipeIds);

    // Build a list of Day objects.
    final List<Day> daysList = dayList.map((dayData) {
      // Filter meals that belong to the current day.
      final mealsForDay =
          mealDataList.where((m) => m.dayId == dayData.id).map((mealData) {
        final recipeData =
            mealRecipes.firstWhere((r) => r.id == mealData.recipeId);

        return Meal(
          id: mealData.id,
          name: mealData.name,
          recipeId: mealData.recipeId,
          recipeName: recipeData.name,
          carbohydratesPerServing: recipeData.carbohydratesPerServing,
          proteinPerServing: recipeData.proteinPerServing,
          fatPerServing: recipeData.fatPerServing,
          caloriesPerServing: recipeData.caloriesPerServing,
        );
      }).toList();

      return Day(
        id: dayData.id,
        name: dayData.name,
        meals: mealsForDay,
      );
    }).toList();

    return MealPlan(
      id: mealPlanData.id,
      name: mealPlanData.name,
      servingsPerMeal: mealPlanData.servingsPerMeal,
      days: daysList,
    );
  }

  // Get a meal plan's recipes' ingredients for adding them to groceries list. Returns a map of ingredient and servings.
  Future<Map<IngredientData, int>> getMealPlanIngredients(
      int mealPlanId) async {
    final mealPlan = await (select(mealPlans)
          ..where((m) => m.id.equals(mealPlanId)))
        .getSingleOrNull();

    final dayQuery =
        (select(days)..where((d) => d.mealPlanId.equals(mealPlanId)));

    final dayIds = await dayQuery.map((row) => row.id).get();

    final mealList =
        await (select(meals)..where((m) => m.dayId.isIn(dayIds))).get();

    // <recipeId, count>
    Map<int, int> recipeCount = {};

    for (var meal in mealList) {
      recipeCount.update(meal.recipeId, (count) => count + 1,
          ifAbsent: () => 1);
    }

    List<IngredientData> ingredientList = await (select(ingredients)
          ..where((i) => i.recipeId.isIn(recipeCount.keys)))
        .get();

    // <Ingredient, count>
    Map<IngredientData, int> ingredientServings = {};

    for (var ingredient in ingredientList) {
      ingredientServings.update(
          ingredient,
          (count) =>
              count +
              mealPlan!.servingsPerMeal * recipeCount[ingredient.recipeId]!,
          ifAbsent: () =>
              (mealPlan!.servingsPerMeal * recipeCount[ingredient.recipeId]!));
    }

    return ingredientServings;
  }
}
