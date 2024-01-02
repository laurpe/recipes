import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/groceries/events.dart';
import 'package:recipes/blocs/groceries/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/grocery.dart';

class GroceriesBloc extends Bloc<GroceriesEvent, GroceriesState> {
  final DatabaseClient databaseClient;

  GroceriesBloc({required this.databaseClient})
      : super(LoadingGroceriesState()) {
    on<ToggleGroceryBought>((event, emit) async {
      try {
        final grocery = event.grocery;

        await databaseClient.toggleGroceryBought(grocery, !grocery.isBought);

        final updatedGrocery = Grocery(
          id: grocery.id,
          name: grocery.name,
          amount: grocery.amount,
          unit: grocery.unit,
          isBought: !grocery.isBought,
        );

        if (state is LoadedGroceriesState) {
          final currentState = state as LoadedGroceriesState;

          final index = currentState.groceries.indexOf(grocery);

          final groceries = currentState.groceries.map((g) {
            if (g.id == grocery.id) {
              return updatedGrocery;
            }
            return g;
          }).toList();

          groceries.removeAt(index);

          event.grocery.isBought
              ? groceries.insert(0, updatedGrocery)
              : groceries.add(updatedGrocery);

          emit(LoadedGroceriesState(groceries: groceries));
        }
      } catch (error) {
        emit(ErrorLoadingGroceriesState());
      }
    });
    on<GetGroceries>((event, emit) async {
      try {
        emit(LoadedGroceriesState(
            groceries: await databaseClient.getGroceries()));
      } catch (error) {
        emit(ErrorLoadingGroceriesState());
      }
    });
    on<DeleteGroceries>((event, emit) async {
      try {
        await databaseClient.deleteGroceries();
        emit(const LoadedGroceriesState(groceries: []));
      } catch (error) {
        emit(ErrorLoadingGroceriesState());
      }
    });
  }
}
