import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/screens/recipe.dart';
import 'package:recipes/widgets/recipe_form.dart';

Future<void> submitRecipe(BuildContext context, Recipe recipe) async {
  List<Tag> existingTags = await GetIt.I<DatabaseClient>().getTags();

  List<int> tagIds = [];

  for (var newTag in recipe.tags!) {
    if (existingTags.any((tag) => tag.name == newTag.name)) {
      Tag existingTag =
          existingTags.firstWhere((tag) => tag.name == newTag.name);
      tagIds.add(existingTag.id!);
    } else {
      int id = await GetIt.I<DatabaseClient>().insertTag(newTag);
      tagIds.add(id);
    }
  }

  int recipeId = await GetIt.I<DatabaseClient>().insertRecipe(recipe);
  await GetIt.I<DatabaseClient>().insertRecipeTags(recipeId, tagIds);

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
              ingredients: [],
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
