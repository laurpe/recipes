import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/recipes/bloc.dart';
import 'package:recipes/blocs/recipes/events.dart';
import 'package:recipes/blocs/recipes/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/screens/add_recipe.dart';
import 'package:recipes/screens/recipe.dart';

Future<void> openAddSingleRecipe(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const RecipeFormView(),
    ),
  );

  if (!context.mounted) return;
  if (result == RecipeResult.added) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Recipe added!')));
    BlocProvider.of<RecipesBloc>(context).add(GetRecipes());
  }
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final databaseClient = GetIt.I<DatabaseClient>();
        return RecipesBloc(databaseClient: databaseClient)..add(GetRecipes());
      },
      child: const RecipeListView(),
    );
  }
}

class RecipeListView extends StatelessWidget {
  const RecipeListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          onPressed: () => openAddSingleRecipe(context),
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (
          BuildContext context,
          RecipesState state,
        ) {
          switch (state) {
            case LoadingRecipesState():
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ErrorLoadingRecipesState():
              return const Center(
                child: Text('Error loading recipes'),
              );
            case LoadedRecipesState():
              return ListView.builder(
                itemCount: state.recipes.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return Card(
                    margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: ListTile(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleRecipe(
                              recipeId: state.recipes[index].id!,
                            ),
                          ),
                        );

                        if (result == RecipeResult.deleted) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Recipe deleted!'),
                            ),
                          );
                        }
                      },
                      title: Text(state.recipes[index].name),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
