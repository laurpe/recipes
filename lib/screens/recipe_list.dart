import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/paginated_recipes/bloc.dart';
import 'package:recipes/blocs/paginated_recipes/events.dart';
import 'package:recipes/blocs/paginated_recipes/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';
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
          ..add(const GetPaginatedRecipes());
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
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              BlocProvider.of<PaginatedRecipesBloc>(context)
                  .add(GetPaginatedRecipes(query: value));
              print(value);
            },
          ),
          Expanded(
            child: BlocBuilder<PaginatedRecipesBloc, PaginatedRecipesState>(
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
                      itemCount: state.recipes.length,
                      itemBuilder: (context, index) {
                        if (index == state.recipes.length - 1) {
                          BlocProvider.of<PaginatedRecipesBloc>(context)
                              .add(GetPaginatedRecipes(offset: index));
                          return const Center(
                            child: SizedBox(),
                          );
                        }
                        return RecipeListTile(recipe: state.recipes[index]);
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeListTile extends StatefulWidget {
  final Recipe recipe;

  const RecipeListTile({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeListTile> createState() => _RecipeListTileState();
}

class _RecipeListTileState extends State<RecipeListTile> {
  late bool _favorite;

  @override
  void initState() {
    _favorite = widget.recipe.favorite;
    super.initState();
  }

  void _toggleFavorite() async {
    setState(() {
      _favorite = !_favorite;
    });
    await GetIt.I<DatabaseClient>()
        .toggleFavoriteRecipe(widget.recipe, _favorite);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: ListTile(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleRecipe(
                recipeId: widget.recipe.id!,
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
        title: Text(widget.recipe.name),
        trailing: IconButton(
          onPressed: () {
            _toggleFavorite();
          },
          icon: _favorite
              ? const Icon(Icons.favorite,
                  color: Color.fromARGB(255, 255, 128, 0))
              : const Icon(Icons.favorite_outline,
                  color: Color.fromARGB(255, 255, 128, 0)),
        ),
      ),
    );
  }
}
