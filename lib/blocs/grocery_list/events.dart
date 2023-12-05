import 'package:equatable/equatable.dart';
import 'package:recipes/grocery.dart';

abstract class GroceryListEvent extends Equatable {
  const GroceryListEvent();

  @override
  get props => [];
}

class GetGroceryList extends GroceryListEvent {}

class AddToGroceryList extends GroceryListEvent {
  final List<Grocery> groceries;

  const AddToGroceryList({required this.groceries});
}
