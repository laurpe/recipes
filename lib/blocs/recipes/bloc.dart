import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/database.dart';
import 'package:recipes/blocs/recipes/events.dart';
import 'package:recipes/blocs/recipes/state.dart';
import 'package:recipes/recipe.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final DatabaseClient databaseClient;

  RecipesBloc({required this.databaseClient}) : super(LoadingRecipesState()) {
    on<GetRecipes>(
      (event, emit) async {
        try {
          List<Recipe> recipes = [];
          int? offset = event.offset;
          String? query = event.query;

          if (state is LoadedRecipesState) {
            final currentState = state as LoadedRecipesState;
            recipes = currentState.recipes;
            offset = offset ?? currentState.offset;
            query = query ?? currentState.query;

            if (query != currentState.query) {
              offset = 0;
              recipes = [];
            }
          }

          final newRecipes = await databaseClient.searchRecipes(
            offset: offset ?? 0,
            query: query ?? '',
          );

          emit(LoadedRecipesState(
            recipes: recipes + newRecipes,
            query: query,
            offset: offset,
          ));
        } catch (error) {
          emit(ErrorLoadingRecipesState());
        }
      },
    );
  }
}
