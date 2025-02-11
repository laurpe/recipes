import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/tags/bloc.dart';
import 'package:recipes/blocs/tags/events.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/screens/recipe.dart';
import 'package:recipes/widgets/recipe_form.dart';

Future<void> submitRecipe(BuildContext context, Recipe recipe) async {
  int recipeId = await GetIt.I<DatabaseClient>().insertRecipe(recipe);

  if (!context.mounted) return;

  BlocProvider.of<TagsBloc>(context).add(AddRecipeTags(recipe.tags!, recipeId));

  if (context.mounted) {
    Navigator.of(context).pop(Added(recipe));
  }
}

class AddRecipeFormView extends StatelessWidget {
  final Recipe initialValues;

  AddRecipeFormView({super.key, Recipe? recipe})
      : initialValues = recipe ??
            Recipe(
              name: '',
              instructions: '',
              ingredients: [
                const Ingredient(
                    name: '', amountPerServing: 0, unit: IngredientUnit.dl)
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
