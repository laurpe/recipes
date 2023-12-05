import 'package:equatable/equatable.dart';
import 'package:recipes/grocery.dart';

sealed class GroceryListState extends Equatable {
  const GroceryListState();

  @override
  get props => [];
}

class LoadedGroceryListState extends GroceryListState {
  final List<Grocery> groceryList;

  const LoadedGroceryListState({required this.groceryList});

  @override
  get props => [groceryList];
}

class LoadingGroceryListState extends GroceryListState {}

class ErrorLoadingGroceryListState extends GroceryListState {}
