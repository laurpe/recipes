import 'package:equatable/equatable.dart';
import 'package:recipes/models/tag.dart';

abstract class TagsEvent extends Equatable {
  const TagsEvent();

  @override
  get props => [];
}

class GetTags extends TagsEvent {}

class AddRecipeTags extends TagsEvent {
  final List<Tag> tags;
  final int recipeId;

  const AddRecipeTags(this.tags, this.recipeId);

  @override
  get props => [tags];
}
