import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/database.dart';
import 'package:recipes/blocs/paginated_recipes/events.dart';
import 'package:recipes/blocs/paginated_recipes/state.dart';
import 'package:recipes/recipe.dart';

class PaginatedRecipesBloc
    extends Bloc<PaginatedRecipesEvent, PaginatedRecipesState> {
  final DatabaseClient databaseClient;

  @override
  void onTransition(
      Transition<PaginatedRecipesEvent, PaginatedRecipesState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  PaginatedRecipesBloc({required this.databaseClient})
      : super(LoadingPaginatedRecipesState()) {
    on<GetPaginatedRecipes>((event, emit) async {
      try {
        /// jos eventillä on query tai offset
        /// yliaja current staten offset ja query
        /// muuten käytä current staten offset ja query
        /// tai defaultoi offset = 0 ja query = ''
        List<Recipe> recipes = [];
        int? offset = event.offset;
        String? query = event.query;

        if (state is LoadedPaginatedRecipesState) {
          final currentState = state as LoadedPaginatedRecipesState;
          recipes = currentState.recipes;
          offset = offset ?? currentState.offset;
          query = query ?? currentState.query;

          if (query != currentState.query) {
            offset = 0;
            recipes = [];
          }
        }

        // emit(LoadingPaginatedRecipesState());

        final newRecipes = await databaseClient.searchRecipes(
          offset: offset ?? 0,
          query: query ?? '',
        );

        emit(LoadedPaginatedRecipesState(
          recipes: recipes + newRecipes,
          query: query,
          offset: offset,
        ));
      } catch (error) {
        emit(ErrorLoadingPaginatedRecipesState());
      }
    });
    on<ResetPagination>((event, emit) async {
      emit(const LoadedPaginatedRecipesState(
        recipes: [],
        query: '',
        offset: 0,
      ));
      add(const GetPaginatedRecipes());
    });
  }
}
