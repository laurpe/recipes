import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/database.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final DatabaseClient databaseClient;
  final int mealPlanId;

  MealPlanBloc({required this.databaseClient, required this.mealPlanId})
      : super(LoadingMealPlanState()) {
    on<GetMealPlan>((event, emit) async {
      try {
        emit(LoadingMealPlanState());
        emit(
          LoadedMealPlanState(
            mealPlan: await databaseClient.getMealPlan(mealPlanId),
          ),
        );
      } catch (error) {
        emit(ErrorLoadingMealPlanState());
      }
    });
  }
}
