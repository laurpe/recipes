import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/recipes/events.dart';
import 'package:recipes/blocs/recipes/state.dart';
import 'package:recipes/models/recipe_list_item.dart';
import 'package:recipes/models/tag.dart';
import 'package:recipes/repositories/recipe_repository.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final RecipeRepository recipeRepository;

  RecipesBloc({required this.recipeRepository}) : super(LoadingRecipesState()) {
    on<RecipeUpdated>(
      (event, emit) async {
        try {
          final recipe = event.recipe;

          if (state is LoadedRecipesState) {
            final currentState = state as LoadedRecipesState;

            final recipes = currentState.recipes.map((r) {
              if (r.id == recipe.id) {
                return recipe.toRecipeListItem();
              }
              return r;
            }).toList();

            emit(LoadedRecipesState(
              recipes: recipes,
              query: currentState.query,
              offset: currentState.offset,
              tags: currentState.tags,
              hasReachedEnd: currentState.hasReachedEnd,
              favorites: currentState.favorites,
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
              favorites: currentState.favorites,
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
          int? offset = event.offset;
          List<RecipeListItem> recipes = [];
          String? query = event.query;
          List<Tag>? tags = event.tags;
          bool? favorites = event.favorites;

          int totalCount = await recipeRepository.getRecipesCount();
          int pageSize = 15;
          int pages = (totalCount / pageSize).ceil();
          int currentPage = (offset ?? 0 / pageSize).ceil() +
              1; // +1 so it starts from page #1, not #0.
          int lastPage = pages;

          if (state is LoadedRecipesState) {
            final currentState = state as LoadedRecipesState;
            recipes = currentState.recipes;
            offset = offset ?? currentState.offset;
            query = query ?? currentState.query;
            tags = tags ?? currentState.tags;
            favorites = favorites ?? currentState.favorites;

            /// Refresh the list if these change.
            if (query != currentState.query ||
                tags != null ||
                favorites != currentState.favorites ||
                recipes.length != totalCount) {
              offset = 0;
              recipes = [];
            }
          }

          final newRecipes = await recipeRepository.searchRecipes(
            offset: offset ?? 0,
            query: query ?? '',
            tags: tags ?? [],
            favorites: favorites ?? false,
          );

          emit(LoadedRecipesState(
            recipes: recipes + newRecipes,
            query: query,
            offset: offset,
            tags: tags,
            hasReachedEnd: currentPage == lastPage,
            favorites: favorites,
          ));
        } catch (error) {
          emit(ErrorLoadingRecipesState());
        }
      },
    );
  }
}
