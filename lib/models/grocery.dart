import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:recipes/database.dart';

class Grocery extends Equatable {
  final int? id;
  final double amount;
  final String unit;
  final String name;
  final bool isBought;
  final int listOrder;

  const Grocery({
    this.id,
    required this.amount,
    required this.unit,
    required this.name,
    required this.isBought,
    required this.listOrder,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'amount': amount,
      'unit': unit,
      'name': name,
      // sqflite wants booleans as a number
      'is_bought': isBought ? 1 : 0,
      'list_order': listOrder,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  GroceriesCompanion toCompanion() {
    return GroceriesCompanion(
      amount: Value(amount),
      unit: Value(unit),
      name: Value(name),
      isBought: Value(isBought),
      listOrder: Value(listOrder),
    );
  }

  Grocery copyWith({
    int? id,
    double? amount,
    String? unit,
    String? name,
    bool? isBought,
    int? listOrder,
  }) {
    return Grocery(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      name: name ?? this.name,
      isBought: isBought ?? this.isBought,
      listOrder: listOrder ?? this.listOrder,
    );
  }

  @override
  List<Object?> get props => [id, amount, unit, name, isBought, listOrder];
}
