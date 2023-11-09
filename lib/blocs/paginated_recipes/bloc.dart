import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/database.dart';
import 'package:recipes/blocs/paginated_recipes/events.dart';
import 'package:recipes/blocs/paginated_recipes/state.dart';
import 'package:recipes/recipe.dart';

class PaginatedRecipesBloc
    extends Bloc<PaginatedRecipesEvent, PaginatedRecipesState> {
  final DatabaseClient databaseClient;

  PaginatedRecipesBloc({required this.databaseClient})
      : super(LoadingPaginatedRecipesState()) {
    on<GetPaginatedRecipes>((event, emit) async {
      try {
        List<Recipe> recipes = [];

        if (state is LoadedPaginatedRecipesState) {
          final currentState = state as LoadedPaginatedRecipesState;
          if (currentState.hasReachedMax) return;
          recipes = currentState.recipes;
        }

        emit(LoadingPaginatedRecipesState());

        final newRecipes = await databaseClient.paginateRecipes(event.offset);

        emit(LoadedPaginatedRecipesState(
          recipes: recipes + newRecipes,
          hasReachedMax: newRecipes.isEmpty,
        ));
      } catch (error) {
        emit(ErrorLoadingPaginatedRecipesState());
      }
    });
  }
}
