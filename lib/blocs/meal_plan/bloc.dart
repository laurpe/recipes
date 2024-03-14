import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/database.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final DatabaseClient databaseClient;

  MealPlanBloc({required this.databaseClient}) : super(LoadingMealPlanState()) {
    on<GetMealPlan>((event, emit) async {
      try {
        emit(LoadingMealPlanState());
        emit(
          LoadedMealPlanState(
            mealPlan: await databaseClient.getMealPlan(event.id),
          ),
        );
      } catch (error) {
        emit(ErrorLoadingMealPlanState());
      }
    });
  }
}
