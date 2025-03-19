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
