import 'package:equatable/equatable.dart';

abstract class PaginatedRecipesEvent extends Equatable {
  const PaginatedRecipesEvent();

  @override
  get props => [];
}

class GetPaginatedRecipes extends PaginatedRecipesEvent {
  final int? offset;
  final String? query;

  const GetPaginatedRecipes({this.offset, this.query});
}

class ResetPagination extends PaginatedRecipesEvent {}
