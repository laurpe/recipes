import 'package:equatable/equatable.dart';
import 'package:recipes/grocery.dart';

sealed class GroceriesState extends Equatable {
  const GroceriesState();

  @override
  get props => [];
}

class LoadedGroceriesState extends GroceriesState {
  final List<Grocery> groceries;

  const LoadedGroceriesState({required this.groceries});

  @override
  get props => [groceries];
}

class LoadingGroceriesState extends GroceriesState {}

class ErrorLoadingGroceriesState extends GroceriesState {}
