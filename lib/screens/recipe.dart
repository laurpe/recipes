import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/recipe/bloc.dart';
import 'package:recipes/blocs/recipe/events.dart';
import 'package:recipes/blocs/recipe/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/screens/edit_recipe.dart';

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
      child: const RecipeView(),
    );
  }
}

class RecipeView extends StatelessWidget {
  const RecipeView({
    super.key,
  });

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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditSingleRecipe(
                                recipe: state.recipe,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit))
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
                            SizedBox(width: 60, child: Text(ingredient.amount)),
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
