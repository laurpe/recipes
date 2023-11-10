import 'package:equatable/equatable.dart';

abstract class PaginatedRecipesEvent extends Equatable {
  const PaginatedRecipesEvent();

  @override
  get props => [];
}

class GetPaginatedRecipes extends PaginatedRecipesEvent {
  final int offset;

  const GetPaginatedRecipes({required this.offset});
}

class ResetPagination extends PaginatedRecipesEvent {}
