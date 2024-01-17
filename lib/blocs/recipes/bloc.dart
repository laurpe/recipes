import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/database.dart';
import 'package:recipes/blocs/recipes/events.dart';
import 'package:recipes/blocs/recipes/state.dart';
import 'package:recipes/recipe.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final DatabaseClient databaseClient;

  RecipesBloc({required this.databaseClient}) : super(LoadingRecipesState()) {
    on<ToggleFavoriteRecipe>(
      (event, emit) async {
        try {
          final recipe = event.recipe;
          await databaseClient.toggleFavoriteRecipe(recipe, !recipe.favorite);
          if (state is LoadedRecipesState) {
            final currentState = state as LoadedRecipesState;

            final recipes = currentState.recipes.map((r) {
              if (r.id == recipe.id) {
                return Recipe(
                  id: recipe.id,
                  name: recipe.name,
                  ingredients: recipe.ingredients,
                  instructions: recipe.instructions,
                  favorite: !recipe.favorite,
                  servings: recipe.servings,
                  tags: recipe.tags,
                );
              }
              return r;
            }).toList();

            emit(LoadedRecipesState(
              recipes: recipes,
              query: currentState.query,
              offset: currentState.offset,
              tags: currentState.tags,
              hasReachedEnd: currentState.hasReachedEnd,
            ));
          }
        } catch (error) {
          emit(ErrorLoadingRecipesState());
        }
      },
    );
    on<RecipeUpdated>(
      (event, emit) async {
        try {
          final recipe = event.recipe;

          if (state is LoadedRecipesState) {
            final currentState = state as LoadedRecipesState;

            final recipes = currentState.recipes.map((r) {
              if (r.id == recipe.id) {
                return recipe;
              }
              return r;
            }).toList();

            emit(LoadedRecipesState(
              recipes: recipes,
              query: currentState.query,
              offset: currentState.offset,
              tags: currentState.tags,
              hasReachedEnd: currentState.hasReachedEnd,
            ));
          }
        } catch (error) {
          emit(ErrorLoadingRecipesState());
        }
      },
    );
    on<RecipeDeleted>(
      (event, emit) async {
        try {
          final recipeId = event.recipeId;

          if (state is LoadedRecipesState) {
            final currentState = state as LoadedRecipesState;

            final recipes =
                currentState.recipes.where((r) => r.id != recipeId).toList();

            emit(LoadedRecipesState(
              recipes: recipes,
              query: currentState.query,
              offset: currentState.offset,
              tags: currentState.tags,
              hasReachedEnd: currentState.hasReachedEnd,
            ));
          }
        } catch (error) {
          emit(ErrorLoadingRecipesState());
        }
      },
    );
    on<GetRecipes>(
      (event, emit) async {
        try {
          List<Recipe> recipes = [];
          int? offset = event.offset;
          String? query = event.query;
          List<Tag>? tags = event.tags;
          bool hasReachedEnd = false;

          if (state is LoadedRecipesState) {
            final currentState = state as LoadedRecipesState;
            recipes = currentState.recipes;
            offset = offset ?? currentState.offset;
            query = query ?? currentState.query;
            tags = tags ?? currentState.tags;
            hasReachedEnd = currentState.hasReachedEnd;

            if (query != currentState.query || tags != null) {
              offset = 0;
              recipes = [];
              hasReachedEnd = false;
            }
          }

          if (hasReachedEnd) {
            return;
          }

          final newRecipes = await databaseClient.searchRecipes(
            offset: offset ?? 0,
            query: query ?? '',
            tags: tags ?? [],
          );

          emit(LoadedRecipesState(
            recipes: recipes + newRecipes,
            query: query,
            offset: offset,
            tags: tags,
            hasReachedEnd: newRecipes.length < 10,
          ));
        } catch (error) {
          emit(ErrorLoadingRecipesState());
        }
      },
    );
  }
}
