import 'package:recipes/models/meal_plan.dart';
import 'package:test/test.dart';

void main() {
  test('should get correct total of macros per day', () {
    final List<Meal> meals = [
      Meal(
        name: 'meal a',
        carbohydratesPerServing: 60,
        proteinPerServing: 20,
        fatPerServing: 30,
        caloriesPerServing: 500,
      ),
      Meal(
        name: 'meal b',
        carbohydratesPerServing: 45,
        proteinPerServing: 35,
        fatPerServing: 10,
        caloriesPerServing: 400,
      ),
      Meal(
        name: 'meal c',
        carbohydratesPerServing: 30,
        proteinPerServing: 15,
        fatPerServing: 20,
        caloriesPerServing: 350,
      ),
    ];

    Day day = Day(
      name: 'day',
      meals: meals,
    );

    double carbs = day.getCarbsPerPerson();
    double protein = day.getProteinPerPerson();
    double fat = day.getFatPerPerson();
    double calories = day.getCaloriesPerPerson();

    expect(
        carbs,
        equals(meals[0].carbohydratesPerServing! +
            meals[1].carbohydratesPerServing! +
            meals[2].carbohydratesPerServing!));

    expect(
        protein,
        equals(meals[0].proteinPerServing! +
            meals[1].proteinPerServing! +
            meals[2].proteinPerServing!));

    expect(
        fat,
        equals(meals[0].fatPerServing! +
            meals[1].fatPerServing! +
            meals[2].fatPerServing!));

    expect(
        calories,
        equals(meals[0].caloriesPerServing! +
            meals[1].caloriesPerServing! +
            meals[2].caloriesPerServing!));
  });
}
