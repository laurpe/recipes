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

        if (state is LoadedGroceriesState) {
          final currentState = state as LoadedGroceriesState;

          final index = currentState.groceries.indexOf(grocery);

          final groceries = currentState.groceries.map((g) {
            if (g.id == grocery.id) {
              return Grocery(
                id: grocery.id,
                name: grocery.name,
                amount: grocery.amount,
                unit: grocery.unit,
                isBought: !grocery.isBought,
              );
            }
            return g;
          }).toList();

          // TODO: unify sorting when fetching list from database, reloading page and toggling grocery bought
          // toggling isBought from false to true: move to top of bought groceries, not top of whole list

          groceries.removeAt(index);

          final newGrocery = Grocery(
            id: grocery.id,
            name: grocery.name,
            amount: grocery.amount,
            unit: grocery.unit,
            isBought: !grocery.isBought,
          );

          if (!event.grocery.isBought) {
            groceries.add(newGrocery);
          } else {
            groceries.insert(0, newGrocery);
          }

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
