import 'package:equatable/equatable.dart';

class MealPlan extends Equatable {
  final int? id;
  final String name;

  const MealPlan({this.id, required this.name});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  List<Object?> get props => [id, name];
}
