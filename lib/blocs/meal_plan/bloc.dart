import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/meal_plan/events.dart';
import 'package:recipes/blocs/meal_plan/state.dart';
import 'package:recipes/repositories/meal_plan_repository.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealPlanRepository mealPlanRepository;
  final int mealPlanId;

  MealPlanBloc({required this.mealPlanRepository, required this.mealPlanId})
      : super(LoadingMealPlanState()) {
    on<GetMealPlan>((event, emit) async {
      try {
        emit(LoadingMealPlanState());
        emit(
          LoadedMealPlanState(
            mealPlan: await mealPlanRepository.getMealPlan(mealPlanId),
          ),
        );
      } catch (error) {
        emit(ErrorLoadingMealPlanState());
      }
    });
  }
}
