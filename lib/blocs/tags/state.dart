import 'package:equatable/equatable.dart';
import 'package:recipes/recipe.dart';

sealed class TagsState extends Equatable {
  const TagsState();

  @override
  get props => [];
}

class LoadedTagsState extends TagsState {
  final List<Tag> tags;

  const LoadedTagsState({required this.tags});

  @override
  get props => [tags];
}

class LoadingTagsState extends TagsState {}

class ErrorLoadingTagsState extends TagsState {}
