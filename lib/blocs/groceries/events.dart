import 'package:equatable/equatable.dart';
import 'package:recipes/grocery.dart';

abstract class GroceriesEvent extends Equatable {
  const GroceriesEvent();

  @override
  get props => [];
}

class GetGroceries extends GroceriesEvent {}

class DeleteGroceries extends GroceriesEvent {}

class ReorderGroceries extends GroceriesEvent {
  final List<Grocery> groceries;

  const ReorderGroceries({required this.groceries});
}
