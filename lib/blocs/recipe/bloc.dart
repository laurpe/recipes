import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/recipe/events.dart';
import 'package:recipes/blocs/recipe/state.dart';
import 'package:recipes/database.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final DatabaseClient databaseClient;
  final int recipeId;

  RecipeBloc({required this.databaseClient, required this.recipeId})
      : super(LoadingRecipeState()) {
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
