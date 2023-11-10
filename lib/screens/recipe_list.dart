import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/paginated_recipes/bloc.dart';
import 'package:recipes/blocs/paginated_recipes/events.dart';
import 'package:recipes/blocs/paginated_recipes/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/screens/add_recipe.dart';
import 'package:recipes/screens/recipe.dart';

Future<void> openAddRecipe(BuildContext context) async {
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
    BlocProvider.of<PaginatedRecipesBloc>(context).add(ResetPagination());
  }
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final databaseClient = GetIt.I<DatabaseClient>();
        return PaginatedRecipesBloc(databaseClient: databaseClient)
          ..add(const GetPaginatedRecipes(offset: 0));
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
          onPressed: () => openAddRecipe(context),
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: BlocBuilder<PaginatedRecipesBloc, PaginatedRecipesState>(
        builder: (
          BuildContext context,
          PaginatedRecipesState state,
        ) {
          switch (state) {
            case LoadingPaginatedRecipesState():
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ErrorLoadingPaginatedRecipesState():
              return const Center(
                child: Text('Error loading recipes'),
              );
            case LoadedPaginatedRecipesState():
              return ListView.builder(
                itemCount: state.hasReachedMax
                    ? state.recipes.length
                    : state.recipes.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.recipes.length) {
                    BlocProvider.of<PaginatedRecipesBloc>(context)
                        .add(GetPaginatedRecipes(offset: index));
                    return const Center(child: CircularProgressIndicator());
                  }
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
                          BlocProvider.of<PaginatedRecipesBloc>(context)
                              .add(ResetPagination());
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
