import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:recipes/database.dart';

class Tag extends Equatable {
  final int? id;
  final String name;

  const Tag({this.id, required this.name});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  TagsCompanion toCompanion() {
    return TagsCompanion(
      name: Value(name),
    );
  }

  Tag copyWith({
    int? id,
    String? name,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
