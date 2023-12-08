import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/recipe/events.dart';
import 'package:recipes/blocs/recipe/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/grocery.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final DatabaseClient databaseClient;
  final int recipeId;

  @override
  void onTransition(Transition<RecipeEvent, RecipeState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  RecipeBloc({required this.databaseClient, required this.recipeId})
      : super(LoadingRecipeState()) {
    on<GetRecipe>((event, emit) async {
      try {
        emit(LoadingRecipeState());
        emit(LoadedRecipeState(
            recipe: await databaseClient.getRecipe(recipeId)));
      } catch (error) {
        emit(ErrorLoadingRecipeState());
      }
    });
    on<AddGroceries>((event, emit) async {
      final groceries = await databaseClient.getGroceries();
      final ingredients = event.ingredients;
      final List<Grocery> newGroceries = [];

      for (var ingredient in ingredients) {
        newGroceries.add(
          Grocery(
            name: ingredient.name,
            amount: ingredient.amount,
            unit: ingredient.unit,
            isBought: false,
          ),
        );
      }

      final allGroceries = groceries + newGroceries;

      /// Converts amount to string without decimal places if it's a whole number
      String amountToString(double amount) {
        String amountAsString = amount.toString();
        return amountAsString.contains('.0')
            ? amountAsString.split('.0')[0]
            : amountAsString;
      }

      /// Converts grocery units to default units
      Grocery unitsToDefaults(Grocery grocery) {
        switch (grocery.unit) {
          case 'tl':
            return Grocery(
              id: grocery.id,
              name: grocery.name,
              amount: amountToString((double.parse(grocery.amount) * 5)),
              unit: 'ml',
              isBought: grocery.isBought,
            );
          case 'rkl':
            return Grocery(
              id: grocery.id,
              name: grocery.name,
              amount: amountToString((double.parse(grocery.amount) * 15)),
              unit: 'ml',
              isBought: grocery.isBought,
            );
          case 'cl':
            return Grocery(
              id: grocery.id,
              name: grocery.name,
              amount: amountToString((double.parse(grocery.amount) * 10)),
              unit: 'ml',
              isBought: grocery.isBought,
            );
          case 'dl':
            return Grocery(
              id: grocery.id,
              name: grocery.name,
              amount: amountToString((double.parse(grocery.amount) * 100)),
              unit: 'ml',
              isBought: grocery.isBought,
            );
          case 'l':
            return Grocery(
              id: grocery.id,
              name: grocery.name,
              amount: amountToString((double.parse(grocery.amount) * 1000)),
              unit: 'ml',
              isBought: grocery.isBought,
            );
          case 'kg':
            return Grocery(
              id: grocery.id,
              name: grocery.name,
              amount: amountToString((double.parse(grocery.amount) * 1000)),
              unit: 'g',
              isBought: grocery.isBought,
            );
          default:
            return grocery;
        }
      }

      List<Grocery> unitCorrectedGroceries = [];

      for (var grocery in allGroceries) {
        unitCorrectedGroceries.add(unitsToDefaults(grocery));
      }

      Map<String, Grocery> resultMap = unitCorrectedGroceries
          .fold(<String, Grocery>{}, (accumulator, grocery) {
        if (accumulator.containsKey(grocery.name)) {
          accumulator[grocery.name] = Grocery(
              id: accumulator[grocery.name]!.id,
              name: grocery.name,
              amount: amountToString(
                  double.parse(accumulator[grocery.name]!.amount) +
                      double.parse(grocery.amount)),
              unit: accumulator[grocery.name]!.unit,
              isBought: accumulator[grocery.name]!.isBought);
          return accumulator;
        }
        accumulator[grocery.name] = grocery;
        return accumulator;
      });

      List<Grocery> finalList = resultMap.values.toList();
      print(finalList);

      try {
        for (var grocery in finalList) {
          grocery.id == null
              ? await databaseClient.insertGrocery(grocery)
              : await databaseClient.updateGrocery(grocery);
        }
      } catch (error) {
        print('Error adding groceries to database');
      }
    });
  }
}
