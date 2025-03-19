import 'package:recipes/database.dart';
import 'package:recipes/models/recipe.dart';

class DataMapper {
  // TODO: handle imagePath
  static Recipe recipeFromData(RecipeData recipeData,
      List<IngredientData> ingredientsData, List<TagData> tagsData) {
    return Recipe(
        id: recipeData.id,
        name: recipeData.name,
        ingredients: ingredientListFromData(ingredientsData),
        instructions: recipeData.instructions,
        favorite: recipeData.favorite,
        servings: recipeData.servings,
        tags: tagListFromData(tagsData),
        carbohydratesPerServing: recipeData.carbohydratesPerServing,
        proteinPerServing: recipeData.proteinPerServing,
        fatPerServing: recipeData.fatPerServing,
        caloriesPerServing: recipeData.caloriesPerServing);
  }

  static Ingredient ingredientFromData(IngredientData data) {
    return Ingredient(
        amountPerServing: data.amountPerServing,
        unit: data.unit,
        name: data.name);
  }

  static List<Ingredient> ingredientListFromData(
      List<IngredientData> dataList) {
    return dataList.map(ingredientFromData).toList();
  }

  static Tag tagFromData(TagData data) {
    return Tag(id: data.id, name: data.name);
  }

  static List<Tag> tagListFromData(List<TagData> dataList) {
    return dataList.map(tagFromData).toList();
  }
}
