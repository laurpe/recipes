import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/recipe/events.dart';
import 'package:recipes/blocs/recipe/state.dart';
import 'package:recipes/repositories/recipe_repository.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;
  final int recipeId;

  RecipeBloc({required this.recipeRepository, required this.recipeId})
      : super(LoadingRecipeState()) {
    on<ToggleFavoriteRecipe>(
      (event, emit) async {
        try {
          if (state is LoadedRecipeState) {
            final currentState = state as LoadedRecipeState;

            await recipeRepository.toggleFavoriteRecipe(currentState.recipe);

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
            recipe: await recipeRepository.getRecipe(recipeId)));
      } catch (error) {
        emit(ErrorLoadingRecipeState());
      }
    });
  }
}
