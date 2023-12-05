import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/groceries/events.dart';
import 'package:recipes/blocs/groceries/state.dart';
import 'package:recipes/database.dart';

class GroceriesBloc extends Bloc<GroceriesEvent, GroceriesState> {
  final DatabaseClient databaseClient;

  GroceriesBloc({required this.databaseClient})
      : super(LoadingGroceriesState()) {
    on<GetGroceries>((event, emit) async {
      try {
        emit(LoadingGroceriesState());
        emit(LoadedGroceriesState(
            groceries: await databaseClient.getGroceries()));
      } catch (error) {
        emit(ErrorLoadingGroceriesState());
      }
    });
    on<AddGroceries>((event, emit) {});
  }
}
