import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/recipes/bloc.dart';
import 'package:recipes/blocs/recipes/events.dart';
import 'package:recipes/blocs/recipes/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/screens/add_recipe.dart';
import 'package:recipes/screens/groceries.dart';
import 'package:recipes/screens/recipe.dart';

Future<void> openAddRecipe(BuildContext context) async {
  final Result? result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const RecipeFormView(),
    ),
  );

  if (!context.mounted) return;
  if (result is Added) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Recipe added!')));
    BlocProvider.of<RecipesBloc>(context).add(const GetRecipes());
  }
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final databaseClient = GetIt.I<DatabaseClient>();
        return RecipesBloc(databaseClient: databaseClient)
          ..add(const GetRecipes());
      },
      child: const RecipeListView(),
    );
  }
}

class RecipeListView extends StatefulWidget {
  const RecipeListView({
    super.key,
  });

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  bool _showFilters = false;
  List<Tag> tags = [];
  List<Tag> selectedTags = [];
  bool _favoriteSelected = false;

  Future<List<Tag>> getUsedTags() async {
    return await GetIt.I<DatabaseClient>().getUsedTags();
  }

  @override
  void initState() {
    super.initState();
    getUsedTags().then((value) => setState(() => tags = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await openAddRecipe(context);

            ///TODO: refactor this to use bloc.
            await getUsedTags().then((value) => setState(() => tags = value));
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
              icon: const Icon(Icons.filter_list)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GroceriesList(),
                    ));
              },
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: Column(
        children: [
          _showFilters
              ? Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        BlocProvider.of<RecipesBloc>(context)
                            .add(GetRecipes(query: value));
                      },
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: -4.0,
                      alignment: WrapAlignment.center,
                      children: [
                        FilterChip(
                            label: const Text('favorite'),
                            selected: _favoriteSelected,
                            onSelected: (selected) {
                              setState(() {
                                _favoriteSelected = selected;
                                BlocProvider.of<RecipesBloc>(context).add(
                                    GetRecipes(favorites: _favoriteSelected));
                              });
                            }),
                        for (final tag in tags)
                          FilterChip(
                            label: Text(tag.name),
                            selected: selectedTags.contains(tag),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedTags.add(tag);
                                  BlocProvider.of<RecipesBloc>(context)
                                      .add(GetRecipes(tags: selectedTags));
                                } else {
                                  selectedTags.remove(tag);
                                  BlocProvider.of<RecipesBloc>(context)
                                      .add(GetRecipes(tags: selectedTags));
                                }
                              });
                            },
                          ),
                      ],
                    ),
                  ],
                )
              : Container(),
          Expanded(
            child: BlocBuilder<RecipesBloc, RecipesState>(
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
                      itemBuilder: (context, index) {
                        if (index == state.recipes.length - 1 &&
                            !state.hasReachedEnd) {
                          BlocProvider.of<RecipesBloc>(context)
                              .add(GetRecipes(offset: index + 1));
                        }
                        return RecipeListTile(
                          key: Key('${state.recipes[index].id}'),
                          recipe: state.recipes[index],
                        );
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

class RecipeListTile extends StatelessWidget {
  final Recipe recipe;

  const RecipeListTile({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          final Result result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleRecipe(
                recipeId: recipe.id!,
              ),
            ),
          );

          if (result is Deleted) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recipe deleted!'),
              ),
            );
            BlocProvider.of<RecipesBloc>(context)
                .add(RecipeDeleted(recipeId: result.data!));
          }

          /// Get recipe when returning from single recipe page
          /// to update list tile if recipe was updated
          if (result is Updated) {
            if (!context.mounted) return;

            BlocProvider.of<RecipesBloc>(context)
                .add(RecipeUpdated(recipe: result.data!));
          }
        },
        title: Row(
          children: [
            Text(recipe.name),
            const SizedBox(width: 8.0),
            recipe.favorite
                ? Icon(Icons.favorite, size: 16, color: Colors.orange[700])
                : Container(),
          ],
        ),
        subtitle: recipe.tags!.isNotEmpty
            ? Text(recipe.tags!.map((tag) => tag.name).join(', '))
            : null,
      ),
    );
  }
}
