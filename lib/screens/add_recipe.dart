import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/tags/bloc.dart';
import 'package:recipes/blocs/tags/events.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe_detail.dart';
import 'package:recipes/screens/recipe.dart';
import 'package:recipes/widgets/recipe_form.dart';

Future<int> submitRecipe(BuildContext context, RecipeDetail recipe) async {
  int recipeId = await GetIt.I<AppDatabase>().recipesDao.addRecipe(recipe);
  await GetIt.I<AppDatabase>()
      .ingredientsDao
      .addIngredients(recipeId, recipe.ingredients);

  if (context.mounted) {
    BlocProvider.of<TagsBloc>(context)
        .add(AddRecipeTags(recipe.tags!, recipeId));

    Navigator.of(context).pop(Added(recipe));
  }

  return recipeId;
}

class AddRecipeFormView extends StatelessWidget {
  final RecipeDetail initialValues;

  AddRecipeFormView({super.key, RecipeDetail? recipe})
      : initialValues = recipe ??
            RecipeDetail(
              name: '',
              instructions: '',
              ingredients: [
                const Ingredient(name: '', amountPerServing: 0, unit: '')
              ],
              favorite: false,
              servings: 4,
              tags: [],
            );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add recipe"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: RecipeForm(
              initialValues: initialValues, submitRecipe: submitRecipe),
        ),
      ),
    );
  }
}
