import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/recipe/bloc.dart';
import 'package:recipes/blocs/recipe/events.dart';
import 'package:recipes/blocs/recipe/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/screens/edit_recipe.dart';

enum RecipeResult { added, updated, deleted }

Future<void> openEditRecipe(BuildContext context, Recipe recipe) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditRecipe(recipe: recipe),
    ),
  );

  if (!context.mounted) return;

  if (result == RecipeResult.updated) {
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

                  Navigator.of(context).pop(RecipeResult.deleted);
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
                  actions: [
                    IconButton(
                        onPressed: () => openEditRecipe(context, state.recipe),
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () async {
                          final result = await confirmRecipeDelete(
                              context, state.recipe.id!);
                          if (result == RecipeResult.deleted) {
                            if (!context.mounted) return;

                            Navigator.of(context).pop(result);
                          }
                        },
                        icon: const Icon(Icons.delete))
                  ]),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                      child: Text('Ingredients',
                          style: Theme.of(context).textTheme.headlineSmall)),
                  Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListView(
                      padding: const EdgeInsets.all(8.0),
                      shrinkWrap: true,
                      children: [
                        for (var ingredient in state.recipe.ingredients)
                          Row(children: [
                            SizedBox(
                                width: 60,
                                child: Text(ingredient.amount.toString())),
                            SizedBox(width: 60, child: Text(ingredient.unit)),
                            Text(ingredient.name)
                          ]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Text(
                      "Instructions",
                      style: Theme.of(context).textTheme.headlineSmall,
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
