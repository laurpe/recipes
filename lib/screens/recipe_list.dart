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
        actions: [
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2.8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                BlocProvider.of<RecipesBloc>(context)
                    .add(GetRecipes(query: value));
              },
            ),
          ),
          const Filters(),
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
        title: Text(recipe.name),
        trailing: IconButton(
          onPressed: () {
            BlocProvider.of<RecipesBloc>(context)
                .add(ToggleFavoriteRecipe(recipe: recipe));
          },
          icon: recipe.favorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_outline),
        ),
        subtitle: recipe.tags!.isNotEmpty
            ? Text(recipe.tags!.map((tag) => tag.name).join(', '))
            : null,
      ),
    );
  }
}

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  FiltersState createState() => FiltersState();
}

class FiltersState extends State<Filters> {
  List<Tag> tags = [];
  List<Tag> selectedTags = [];

  Future<List<Tag>> getTags() async {
    return await GetIt.I<DatabaseClient>().getTags();
  }

  @override
  void initState() {
    super.initState();
    getTags().then((value) => setState(() => tags = value));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: -4.0,
      alignment: WrapAlignment.center,
      children: [
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
    );
  }
}
