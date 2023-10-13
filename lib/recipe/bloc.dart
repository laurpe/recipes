import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/recipe/events.dart';
import 'package:recipes/recipe/state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final Recipe recipe;

  RecipeBloc({required this.recipe}) : super(LoadingRecipeState()) {
    on<GetRecipe>((event, emit) async {
      try {
        emit(LoadingRecipeState());
        emit(LoadedRecipeState(recipe: recipe));
      } catch (error) {
        emit(ErrorLoadingRecipeState());
      }
    });
  }
}
