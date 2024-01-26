import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/meal_plans/events.dart';
import 'package:recipes/blocs/meal_plans/state.dart';
import 'package:recipes/database.dart';

class MealPlansBloc extends Bloc<MealPlansEvent, MealPlansState> {
  final DatabaseClient databaseClient;

  MealPlansBloc({required this.databaseClient})
      : super(LoadingMealPlansState()) {
    on<GetMealPlans>((event, emit) async {
      try {
        emit(LoadingMealPlansState());
        emit(LoadedMealPlansState(
            mealPlans: await databaseClient.getMealPlans()));
      } catch (error) {
        emit(ErrorLoadingMealPlansState());
      }
    });
  }
}
