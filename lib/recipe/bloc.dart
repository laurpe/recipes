import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe/events.dart';
import 'package:recipes/recipe/state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final DatabaseClient databaseClient;

  RecipeBloc({required this.databaseClient}) : super(LoadingRecipesState());

  Stream<RecipeState> mapEventToState(RecipeEvent event) async* {
    if (event is GetRecipes) {
      try {
        yield LoadingRecipesState();
        yield LoadedRecipesState(recipes: await databaseClient.getRecipes());
      } catch (error) {
        yield ErrorLoadingRecipesState();
      }
    }
  }
}
