import 'package:equatable/equatable.dart';

class Grocery extends Equatable {
  final int? id;
  final String amount;
  final String unit;
  final String name;
  final bool isBought;

  const Grocery(
      {this.id,
      required this.amount,
      required this.unit,
      required this.name,
      required this.isBought});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'amount': amount,
      'unit': unit,
      'name': name,
      'is_bought': isBought,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  List<Object?> get props => [id, amount, unit, name, isBought];
}
