import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/recipe/events.dart';
import 'package:recipes/blocs/recipe/state.dart';
import 'package:recipes/database_old.dart';

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

            final updatedRecipe = currentState.recipe.copyWith(
              favorite: !currentState.recipe.favorite,
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
