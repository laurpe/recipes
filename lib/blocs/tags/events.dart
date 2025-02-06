import 'package:equatable/equatable.dart';

abstract class TagsEvent extends Equatable {
  const TagsEvent();

  @override
  get props => [];
}

class GetTags extends TagsEvent {}
