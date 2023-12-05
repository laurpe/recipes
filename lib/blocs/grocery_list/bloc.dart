import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/grocery_list/events.dart';
import 'package:recipes/blocs/grocery_list/state.dart';
import 'package:recipes/database.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  final DatabaseClient databaseClient;

  GroceryListBloc({required this.databaseClient})
      : super(LoadingGroceryListState()) {
    on<GetGroceryList>((event, emit) async {
      try {
        emit(LoadingGroceryListState());
        emit(LoadedGroceryListState(
            groceryList: await databaseClient.getGroceries()));
      } catch (error) {
        emit(ErrorLoadingGroceryListState());
      }
    });
    on<AddToGroceryList>((event, emit) {});
  }
}
