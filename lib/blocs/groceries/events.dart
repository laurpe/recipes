import 'package:equatable/equatable.dart';

abstract class GroceriesEvent extends Equatable {
  const GroceriesEvent();

  @override
  get props => [];
}

class GetGroceries extends GroceriesEvent {}
