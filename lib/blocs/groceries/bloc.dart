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
          }).toList()
            ..sort((a, b) {
              if (a.isBought && !b.isBought) {
                return 1;
              } else if (!a.isBought && b.isBought) {
                return -1;
              }
              return 0;
            });

          emit(LoadedGroceriesState(groceries: groceries));
        }
      } catch (error) {
        emit(ErrorLoadingGroceriesState());
      }
    });
    on<GetGroceries>((event, emit) async {
      try {
        emit(LoadedGroceriesState(
            groceries: await databaseClient.getGroceries()
              ..sort((a, b) {
                if (a.isBought && !b.isBought) {
                  return 1;
                } else if (!a.isBought && b.isBought) {
                  return -1;
                }
                return 0;
              })));
      } catch (error) {
        emit(ErrorLoadingGroceriesState());
      }
    });
  }
}
