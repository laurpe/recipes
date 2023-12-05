import 'package:equatable/equatable.dart';
import 'package:recipes/grocery.dart';

abstract class GroceriesEvent extends Equatable {
  const GroceriesEvent();

  @override
  get props => [];
}

class GetGroceries extends GroceriesEvent {}

class AddGroceries extends GroceriesEvent {
  final List<Grocery> groceries;

  const AddGroceries({required this.groceries});
}
