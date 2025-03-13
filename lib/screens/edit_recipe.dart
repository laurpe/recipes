import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/tags/bloc.dart';
import 'package:recipes/blocs/tags/events.dart';
import 'package:recipes/database_old.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/screens/recipe.dart';
import 'package:recipes/widgets/recipe_form.dart';

Future<int> submitRecipe(BuildContext context, Recipe recipe) async {
  await GetIt.I<DatabaseClient>().updateRecipe(recipe);

  if (context.mounted) {
    BlocProvider.of<TagsBloc>(context)
        .add(AddRecipeTags(recipe.tags!, recipe.id!));

    Navigator.of(context).pop(Updated(recipe));
  }

  return recipe.id!;
}

class EditRecipeFormView extends StatelessWidget {
  final Recipe initialValues;

  EditRecipeFormView({super.key, Recipe? recipe})
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
        title: const Text('Edit recipe'),
        centerTitle: false,
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
