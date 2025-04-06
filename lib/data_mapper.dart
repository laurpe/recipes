import 'package:recipes/database/database.dart';
import 'package:recipes/models/grocery.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/meal_recipe.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/models/tag.dart';

class DataMapper {
  static Recipe recipeFromData(
      RecipeData recipeData,
      List<IngredientData> ingredientsData,
      List<TagData> tagsData,
      RecipeImageData? imageData,
      String? path) {
    return Recipe(
        id: recipeData.id,
        name: recipeData.name,
        ingredients: ingredientsFromData(ingredientsData),
        instructions: recipeData.instructions,
        favorite: recipeData.favorite,
        servings: recipeData.servings,
        tags: tagsFromData(tagsData),
        imagePath: imageData != null ? '$path/images/${imageData.path}' : null,
        carbohydratesPerServing: recipeData.carbohydratesPerServing,
        proteinPerServing: recipeData.proteinPerServing,
        fatPerServing: recipeData.fatPerServing,
        caloriesPerServing: recipeData.caloriesPerServing);
  }

  static List<Recipe> recipesFromData(List<RecipeData> data) {
    return data.map((item) {
      return Recipe(
        id: item.id,
        name: item.name,
        instructions: item.instructions,
        favorite: item.favorite,
        servings: item.servings,
      );
    }).toList();
  }

  static Ingredient ingredientFromData(IngredientData data) {
    return Ingredient(
        id: data.id,
        amountPerServing: data.amountPerServing,
        unit: data.unit,
        name: data.name);
  }

  static List<Ingredient> ingredientsFromData(List<IngredientData> data) {
    return data.map(ingredientFromData).toList();
  }

  static Tag tagFromData(TagData data) {
    return Tag(id: data.id, name: data.name);
  }

  static List<Tag> tagsFromData(List<TagData> data) {
    return data.map(tagFromData).toList();
  }

  static List<Grocery> groceriesFromData(List<GroceryData> data) {
    return data.map((item) {
      return Grocery(
          id: item.id,
          name: item.name,
          amount: item.amount,
          unit: item.unit,
          isBought: item.isBought,
          listOrder: item.listOrder);
    }).toList();
  }

  static List<MealRecipe> mealRecipesFromData(List<RecipeData> data) {
    return data.map((item) {
      return MealRecipe(
        id: item.id,
        name: item.name,
        carbohydratesPerServing: item.caloriesPerServing,
        proteinPerServing: item.proteinPerServing,
        fatPerServing: item.fatPerServing,
        caloriesPerServing: item.caloriesPerServing,
      );
    }).toList();
  }
}
