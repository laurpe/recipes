import 'package:equatable/equatable.dart';
import 'package:recipes/grocery.dart';

abstract class GroceriesEvent extends Equatable {
  const GroceriesEvent();

  @override
  get props => [];
}

class GetGroceries extends GroceriesEvent {}

class ToggleGroceryBought extends GroceriesEvent {
  final Grocery grocery;

  const ToggleGroceryBought({required this.grocery});
}

class DeleteGroceries extends GroceriesEvent {}

class ReorderGroceries extends GroceriesEvent {
  final List<Grocery> groceries;

  const ReorderGroceries({required this.groceries});
}
