import 'package:equatable/equatable.dart';
import 'package:recipes/models/tag.dart';

class RecipeListItem extends Equatable {
  final int? id;
  final String name;
  final bool favorite;
  final List<Tag>? tags;
  final String? imagePath;

  const RecipeListItem({
    this.id,
    required this.name,
    required this.favorite,
    this.tags,
    this.imagePath,
  });

  RecipeListItem copyWith({
    int? id,
    String? name,
    bool? favorite,
    List<Tag>? tags,
    String? imagePath,
  }) {
    return RecipeListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      favorite: favorite ?? this.favorite,
      tags: tags ?? this.tags,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        favorite,
        tags,
        imagePath,
      ];
}
