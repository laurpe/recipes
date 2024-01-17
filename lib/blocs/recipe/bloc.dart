import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/recipe/events.dart';
import 'package:recipes/blocs/recipe/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final DatabaseClient databaseClient;
  final int recipeId;

  RecipeBloc({required this.databaseClient, required this.recipeId})
      : super(LoadingRecipeState()) {
    on<ToggleFavoriteRecipe>(
      (event, emit) async {
        try {
          if (state is LoadedRecipeState) {
            final currentState = state as LoadedRecipeState;

            await databaseClient.toggleFavoriteRecipe(
                currentState.recipe, !currentState.recipe.favorite);

            final updatedRecipe = Recipe(
              id: currentState.recipe.id,
              name: currentState.recipe.name,
              ingredients: currentState.recipe.ingredients,
              instructions: currentState.recipe.instructions,
              favorite: !currentState.recipe.favorite,
              servings: currentState.recipe.servings,
              tags: currentState.recipe.tags,
            );

            emit(LoadedRecipeState(
              recipe: updatedRecipe,
            ));
          }
        } catch (error) {
          emit(ErrorLoadingRecipeState());
        }
      },
    );
    on<GetRecipe>((event, emit) async {
      try {
        emit(LoadingRecipeState());
        emit(LoadedRecipeState(
            recipe: await databaseClient.getRecipe(recipeId)));
      } catch (error) {
        emit(ErrorLoadingRecipeState());
      }
    });
  }
}
