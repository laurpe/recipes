import 'package:recipes/database.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe_detail.dart';
import 'package:recipes/models/tag.dart';

class DataMapper {
  static RecipeDetail recipeFromData(
      RecipeData recipeData,
      List<IngredientData> ingredientsData,
      List<TagData> tagsData,
      RecipeImageData? imageData) {
    return RecipeDetail(
        id: recipeData.id,
        name: recipeData.name,
        ingredients: ingredientListFromData(ingredientsData),
        instructions: recipeData.instructions,
        favorite: recipeData.favorite,
        servings: recipeData.servings,
        tags: tagListFromData(tagsData),
        imagePath: imageData?.path,
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
