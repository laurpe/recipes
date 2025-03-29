import 'package:recipes/database.dart';
import 'package:recipes/models/grocery.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/meal_recipe.dart';
import 'package:recipes/models/recipe_detail.dart';
import 'package:recipes/models/recipe_list_item.dart';
import 'package:recipes/models/tag.dart';

class DataMapper {
  static RecipeDetail recipeFromData(
      RecipeData recipeData,
      List<IngredientData> ingredientsData,
      List<TagData> tagsData,
      RecipeImageData? imageData,
      String? path) {
    return RecipeDetail(
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

  // Use RecipeListItem to avoid creating another model for recipe with only id and name. Favorite is not needed but is required by the model.
  static List<RecipeListItem> recipesFromData(List<RecipeData> data) {
    return data.map((recipe) {
      return RecipeListItem(
          id: recipe.id, name: recipe.name, favorite: recipe.favorite);
    }).toList();
  }

  static Ingredient ingredientFromData(IngredientData data) {
    return Ingredient(
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
