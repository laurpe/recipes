import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipes/events.dart';
import 'package:recipes/recipes/state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final DatabaseClient databaseClient;

  RecipesBloc({required this.databaseClient}) : super(LoadingRecipesState()) {
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
