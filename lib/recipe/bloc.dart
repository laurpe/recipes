import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe/events.dart';
import 'package:recipes/recipe/state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final DatabaseClient databaseClient;

  RecipeBloc({required this.databaseClient}) : super(LoadingRecipesState()) {
    on<GetRecipes>((event, emit) async {
      try {
        emit(LoadingRecipesState());
        emit(LoadedRecipesState(recipes: await databaseClient.getRecipes()));
      } catch (error) {
        emit(ErrorLoadingRecipesState());
      }
    });
  }
}
