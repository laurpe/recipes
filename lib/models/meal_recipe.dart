class MealRecipe {
  final int id;
  final String name;
  final double? carbohydratesPerServing;
  final double? proteinPerServing;
  final double? fatPerServing;
  final double? caloriesPerServing;

  const MealRecipe(
      {required this.id,
      required this.name,
      this.carbohydratesPerServing,
      this.proteinPerServing,
      this.fatPerServing,
      this.caloriesPerServing});
}
