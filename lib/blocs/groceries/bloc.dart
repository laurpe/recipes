import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/groceries/events.dart';
import 'package:recipes/blocs/groceries/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/grocery.dart';

class GroceriesBloc extends Bloc<GroceriesEvent, GroceriesState> {
  final DatabaseClient databaseClient;

  GroceriesBloc({required this.databaseClient})
      : super(LoadingGroceriesState()) {
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
    on<ReorderGroceries>((event, emit) async {
      List<Grocery> reorderedGroceries = [];

      for (var grocery in event.groceries) {
        reorderedGroceries.add(Grocery(
            id: grocery.id,
            amount: grocery.amount,
            unit: grocery.unit,
            name: grocery.name,
            isBought: grocery.isBought,
            listOrder: event.groceries.indexOf(grocery)));
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
