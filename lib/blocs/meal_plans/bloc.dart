import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/meal_plans/events.dart';
import 'package:recipes/blocs/meal_plans/state.dart';
import 'package:recipes/repositories/meal_plan_repository.dart';

class MealPlansBloc extends Bloc<MealPlansEvent, MealPlansState> {
  final MealPlanRepository mealPlanRepository;

  MealPlansBloc({required this.mealPlanRepository})
      : super(LoadingMealPlansState()) {
    on<GetMealPlans>((event, emit) async {
      try {
        emit(LoadingMealPlansState());
        emit(LoadedMealPlansState(
            mealPlans: await mealPlanRepository.getMealPlansList()));
      } catch (error) {
        emit(ErrorLoadingMealPlansState());
      }
    });
    on<MealPlanUpdated>(
      (event, emit) async {
        try {
          final mealPlan = event.mealPlan;

          if (state is LoadedMealPlansState) {
            final currentState = state as LoadedMealPlansState;

            final mealPlans = currentState.mealPlans.map((r) {
              if (r.id == mealPlan.id) {
                return mealPlan;
              }
              return r;
            }).toList();

            emit(LoadedMealPlansState(
              mealPlans: mealPlans,
            ));
          }
        } catch (error) {
          emit(ErrorLoadingMealPlansState());
        }
      },
    );
    on<MealPlanDeleted>(
      (event, emit) async {
        try {
          final mealPlanId = event.mealPlanId;

          if (state is LoadedMealPlansState) {
            final currentState = state as LoadedMealPlansState;

            final mealPlans = currentState.mealPlans
                .where((r) => r.id != mealPlanId)
                .toList();

            emit(LoadedMealPlansState(
              mealPlans: mealPlans,
            ));
          }
        } catch (error) {
          emit(ErrorLoadingMealPlansState());
        }
      },
    );
  }
}
