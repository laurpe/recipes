import 'package:equatable/equatable.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  get props => [];
}

class GetRecipes extends RecipesEvent {
  final int? offset;
  final String? query;

  const GetRecipes({this.offset, this.query});
}
