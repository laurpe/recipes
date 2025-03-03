import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/recipe/bloc.dart';
import 'package:recipes/blocs/recipe/events.dart';
import 'package:recipes/blocs/recipe/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/helpers/add_ingredients_to_groceries.dart';
import 'package:recipes/helpers/ingredient_formatters.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/screens/edit_recipe.dart';

sealed class Result<T> {
  final T? data;

  Result(this.data);
}

class Updated extends Result<Recipe> {
  Updated(Recipe data) : super(data);
}

class Deleted extends Result<int> {
  Deleted(int data) : super(data);
}

class Added extends Result<Recipe> {
  Added(Recipe data) : super(data);
}

Future<void> addRecipeToGroceries(Recipe recipe, BuildContext context) async {
  try {
    await addIngredientsToGroceries(recipe, recipe.servings);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ingredients added to grocery list!'),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not add ingredients to grocery list.'),
      ),
    );
  }
}

Future<void> openEditRecipe(BuildContext context, Recipe recipe) async {
  final Result? result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditRecipeFormView(recipe: recipe),
    ),
  );

  if (!context.mounted) return;

  if (result is Updated) {
    BlocProvider.of<RecipeBloc>(context).add(GetRecipe());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe updated!'),
      ),
    );
  }
}

class SingleRecipe extends StatelessWidget {
  final int recipeId;

  const SingleRecipe({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final databaseClient = GetIt.I<DatabaseClient>();
        return RecipeBloc(databaseClient: databaseClient, recipeId: recipeId)
          ..add(GetRecipe());
      },
      child: const SingleRecipeView(),
    );
  }
}

class SingleRecipeView extends StatelessWidget {
  const SingleRecipeView({
    super.key,
  });

  Future confirmRecipeDelete(BuildContext context, int recipeId) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this recipe?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                try {
                  await GetIt.I<DatabaseClient>().deleteRecipe(recipeId);

                  if (!context.mounted) return;

                  Navigator.of(context).pop(Deleted(recipeId));
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Could not delete recipe! Please try again.')));
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        switch (state) {
          case LoadingRecipeState():
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ErrorLoadingRecipeState():
            return const Center(
              child: Text('Error loading recipe'),
            );

          case LoadedRecipeState():
            return Scaffold(
              appBar: AppBar(
                  title: Text(state.recipe.name),
                  centerTitle: false,
                  leading: IconButton(
                      onPressed: () =>
                          Navigator.of(context).pop(Updated(state.recipe)),
                      icon: const Icon(Icons.arrow_back_ios)),
                  actions: [
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<RecipeBloc>(context)
                              .add(const ToggleFavoriteRecipe());
                        },
                        icon: state.recipe.favorite
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border)),
                    MenuAnchor(
                      builder: (context, controller, child) {
                        return IconButton(
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          icon: const Icon(Icons.more_vert),
                          tooltip: 'Show menu',
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          child: const Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                          onPressed: () {
                            openEditRecipe(context, state.recipe);
                          },
                        ),
                        MenuItemButton(
                            child: const Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                            onPressed: () async {
                              final Result? result = await confirmRecipeDelete(
                                  context, state.recipe.id!);
                              if (result is Deleted) {
                                if (!context.mounted) return;

                                Navigator.of(context)
                                    .pop(Deleted(result.data!));
                              }
                            }),
                        MenuItemButton(
                          child: const Row(
                            children: [
                              Icon(Icons.add_shopping_cart),
                              SizedBox(width: 8),
                              Text('Add to groceries'),
                            ],
                          ),
                          onPressed: () {
                            addRecipeToGroceries(state.recipe, context);
                          },
                        ),
                      ],
                    )
                  ]),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  state.recipe.imagePath != null
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(state.recipe.imagePath!),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                    child: Text('Servings: ${state.recipe.servings}'),
                  ),
                  state.recipe.carbohydratesPerServing == null &&
                          state.recipe.proteinPerServing == null &&
                          state.recipe.fatPerServing == null &&
                          state.recipe.caloriesPerServing == null
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Macronutrients per serving:'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(child: Text('Carbs')),
                                      TableCell(child: Text('Protein')),
                                      TableCell(child: Text('Fat')),
                                      TableCell(child: Text('Calories')),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: Text(state.recipe
                                                      .carbohydratesPerServing !=
                                                  null
                                              ? '${removeTrailingZero(state.recipe.carbohydratesPerServing!)} g'
                                              : '')),
                                      TableCell(
                                          child: Text(state.recipe
                                                      .proteinPerServing !=
                                                  null
                                              ? '${removeTrailingZero(state.recipe.proteinPerServing!)} g'
                                              : '')),
                                      TableCell(
                                          child: Text(state
                                                      .recipe.fatPerServing !=
                                                  null
                                              ? '${removeTrailingZero(state.recipe.fatPerServing!)} g'
                                              : '')),
                                      TableCell(
                                          child: Text(state.recipe
                                                      .caloriesPerServing !=
                                                  null
                                              ? '${removeTrailingZero(state.recipe.caloriesPerServing!)} kcal'
                                              : '')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                    child: state.recipe.tags!.isNotEmpty
                        ? Text(
                            'Tags: ${state.recipe.tags!.map((tag) => tag.name).join(', ')}')
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                    child: Text('Ingredients',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                    child: ListView(
                      padding: const EdgeInsets.all(8.0),
                      shrinkWrap: true,
                      children: [
                        for (var ingredient in state.recipe.ingredients)
                          Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(
                                  formatIngredientAmount(
                                      ingredient.amountPerServing *
                                          state.recipe.servings),
                                ),
                              ),
                              SizedBox(width: 60, child: Text(ingredient.unit)),
                              Text(ingredient.name)
                            ],
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Text(
                      "Instructions",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(state.recipe.instructions),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
