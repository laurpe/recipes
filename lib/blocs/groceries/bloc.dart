import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/groceries/events.dart';
import 'package:recipes/blocs/groceries/state.dart';
import 'package:recipes/database_old.dart';
import 'package:recipes/models/grocery.dart';

class GroceriesBloc extends Bloc<GroceriesEvent, GroceriesState> {
  final DatabaseClient databaseClient;

  GroceriesBloc({required this.databaseClient})
      : super(LoadingGroceriesState()) {
    on<GetGroceries>((event, emit) async {
      try {
        List<Grocery> groceries = await databaseClient.getGroceries();
        groceries.sort((a, b) {
          if (a.isBought && !b.isBought) {
            return 1;
          } else if (!a.isBought && b.isBought) {
            return -1;
          }
          return 0;
        });

        emit(LoadedGroceriesState(groceries: groceries));
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
    on<ReorderGroceries>((event, emit) async {
      List<Grocery> reorderedGroceries = [];

      for (var grocery in event.groceries) {
        reorderedGroceries
            .add(grocery.copyWith(listOrder: event.groceries.indexOf(grocery)));
      }

      try {
        for (var grocery in reorderedGroceries) {
          await databaseClient.updateGrocery(grocery);
        }
        emit(LoadedGroceriesState(groceries: event.groceries));
      } catch (error) {
        emit(ErrorLoadingGroceriesState());
      }
    });
  }
}
