import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/tags/bloc.dart';
import 'package:recipes/blocs/tags/events.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/recipe_detail.dart';
import 'package:recipes/screens/recipe.dart';
import 'package:recipes/widgets/recipe_form.dart';

Future<int> submitRecipe(BuildContext context, RecipeDetail recipe) async {
  await GetIt.I<AppDatabase>().recipesDao.updateRecipe(recipe);
  await GetIt.I<AppDatabase>()
      .ingredientsDao
      .updateRecipeIngredients(recipe.id!, recipe.ingredients);

  if (context.mounted) {
    BlocProvider.of<TagsBloc>(context)
        .add(AddRecipeTags(recipe.tags!, recipe.id!));

    Navigator.of(context).pop(Updated(recipe));
  }

  return recipe.id!;
}

class EditRecipeFormView extends StatelessWidget {
  final RecipeDetail initialValues;

  EditRecipeFormView({super.key, RecipeDetail? recipe})
      : initialValues = recipe ??
            RecipeDetail(
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
