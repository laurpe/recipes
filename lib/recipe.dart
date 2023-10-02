class Ingredient {
  int? id;
  String amount;
  String name;

  Ingredient({this.id, required this.amount, required this.name});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'amount': amount,
      'name': name,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Ingredient{id: $id, amount: $amount, name: $name}';
  }
}

class Recipe {
  int? id;
  String name;
  List<Ingredient> ingredients;
  String instructions;

  Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'instructions': instructions,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}
