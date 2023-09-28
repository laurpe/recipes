class Ingredient {
  String amount;
  String name;

  Ingredient({required this.amount, required this.name});
}

class Recipe {
  String name;
  List<Ingredient> ingredients;
  String instructions;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.instructions,
  });
}
