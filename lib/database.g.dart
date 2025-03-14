// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes with TableInfo<$RecipesTable, RecipeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _carbohydratesPerServingMeta =
      const VerificationMeta('carbohydratesPerServing');
  @override
  late final GeneratedColumn<double> carbohydratesPerServing =
      GeneratedColumn<double>('carbohydrates_per_serving', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _proteinPerServingMeta =
      const VerificationMeta('proteinPerServing');
  @override
  late final GeneratedColumn<double> proteinPerServing =
      GeneratedColumn<double>('protein_per_serving', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatPerServingMeta =
      const VerificationMeta('fatPerServing');
  @override
  late final GeneratedColumn<double> fatPerServing = GeneratedColumn<double>(
      'fat_per_serving', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _caloriesPerServingMeta =
      const VerificationMeta('caloriesPerServing');
  @override
  late final GeneratedColumn<double> caloriesPerServing =
      GeneratedColumn<double>('calories_per_serving', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        instructions,
        favorite,
        servings,
        carbohydratesPerServing,
        proteinPerServing,
        fatPerServing,
        caloriesPerServing
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    } else if (isInserting) {
      context.missing(_servingsMeta);
    }
    if (data.containsKey('carbohydrates_per_serving')) {
      context.handle(
          _carbohydratesPerServingMeta,
          carbohydratesPerServing.isAcceptableOrUnknown(
              data['carbohydrates_per_serving']!,
              _carbohydratesPerServingMeta));
    }
    if (data.containsKey('protein_per_serving')) {
      context.handle(
          _proteinPerServingMeta,
          proteinPerServing.isAcceptableOrUnknown(
              data['protein_per_serving']!, _proteinPerServingMeta));
    }
    if (data.containsKey('fat_per_serving')) {
      context.handle(
          _fatPerServingMeta,
          fatPerServing.isAcceptableOrUnknown(
              data['fat_per_serving']!, _fatPerServingMeta));
    }
    if (data.containsKey('calories_per_serving')) {
      context.handle(
          _caloriesPerServingMeta,
          caloriesPerServing.isAcceptableOrUnknown(
              data['calories_per_serving']!, _caloriesPerServingMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions'])!,
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings'])!,
      carbohydratesPerServing: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}carbohydrates_per_serving']),
      proteinPerServing: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}protein_per_serving']),
      fatPerServing: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat_per_serving']),
      caloriesPerServing: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}calories_per_serving']),
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class RecipeData extends DataClass implements Insertable<RecipeData> {
  final int id;
  final String name;
  final String instructions;
  final bool favorite;
  final int servings;
  final double? carbohydratesPerServing;
  final double? proteinPerServing;
  final double? fatPerServing;
  final double? caloriesPerServing;
  const RecipeData(
      {required this.id,
      required this.name,
      required this.instructions,
      required this.favorite,
      required this.servings,
      this.carbohydratesPerServing,
      this.proteinPerServing,
      this.fatPerServing,
      this.caloriesPerServing});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['instructions'] = Variable<String>(instructions);
    map['favorite'] = Variable<bool>(favorite);
    map['servings'] = Variable<int>(servings);
    if (!nullToAbsent || carbohydratesPerServing != null) {
      map['carbohydrates_per_serving'] =
          Variable<double>(carbohydratesPerServing);
    }
    if (!nullToAbsent || proteinPerServing != null) {
      map['protein_per_serving'] = Variable<double>(proteinPerServing);
    }
    if (!nullToAbsent || fatPerServing != null) {
      map['fat_per_serving'] = Variable<double>(fatPerServing);
    }
    if (!nullToAbsent || caloriesPerServing != null) {
      map['calories_per_serving'] = Variable<double>(caloriesPerServing);
    }
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      instructions: Value(instructions),
      favorite: Value(favorite),
      servings: Value(servings),
      carbohydratesPerServing: carbohydratesPerServing == null && nullToAbsent
          ? const Value.absent()
          : Value(carbohydratesPerServing),
      proteinPerServing: proteinPerServing == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinPerServing),
      fatPerServing: fatPerServing == null && nullToAbsent
          ? const Value.absent()
          : Value(fatPerServing),
      caloriesPerServing: caloriesPerServing == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesPerServing),
    );
  }

  factory RecipeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      instructions: serializer.fromJson<String>(json['instructions']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      servings: serializer.fromJson<int>(json['servings']),
      carbohydratesPerServing:
          serializer.fromJson<double?>(json['carbohydratesPerServing']),
      proteinPerServing:
          serializer.fromJson<double?>(json['proteinPerServing']),
      fatPerServing: serializer.fromJson<double?>(json['fatPerServing']),
      caloriesPerServing:
          serializer.fromJson<double?>(json['caloriesPerServing']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'instructions': serializer.toJson<String>(instructions),
      'favorite': serializer.toJson<bool>(favorite),
      'servings': serializer.toJson<int>(servings),
      'carbohydratesPerServing':
          serializer.toJson<double?>(carbohydratesPerServing),
      'proteinPerServing': serializer.toJson<double?>(proteinPerServing),
      'fatPerServing': serializer.toJson<double?>(fatPerServing),
      'caloriesPerServing': serializer.toJson<double?>(caloriesPerServing),
    };
  }

  RecipeData copyWith(
          {int? id,
          String? name,
          String? instructions,
          bool? favorite,
          int? servings,
          Value<double?> carbohydratesPerServing = const Value.absent(),
          Value<double?> proteinPerServing = const Value.absent(),
          Value<double?> fatPerServing = const Value.absent(),
          Value<double?> caloriesPerServing = const Value.absent()}) =>
      RecipeData(
        id: id ?? this.id,
        name: name ?? this.name,
        instructions: instructions ?? this.instructions,
        favorite: favorite ?? this.favorite,
        servings: servings ?? this.servings,
        carbohydratesPerServing: carbohydratesPerServing.present
            ? carbohydratesPerServing.value
            : this.carbohydratesPerServing,
        proteinPerServing: proteinPerServing.present
            ? proteinPerServing.value
            : this.proteinPerServing,
        fatPerServing:
            fatPerServing.present ? fatPerServing.value : this.fatPerServing,
        caloriesPerServing: caloriesPerServing.present
            ? caloriesPerServing.value
            : this.caloriesPerServing,
      );
  RecipeData copyWithCompanion(RecipesCompanion data) {
    return RecipeData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      servings: data.servings.present ? data.servings.value : this.servings,
      carbohydratesPerServing: data.carbohydratesPerServing.present
          ? data.carbohydratesPerServing.value
          : this.carbohydratesPerServing,
      proteinPerServing: data.proteinPerServing.present
          ? data.proteinPerServing.value
          : this.proteinPerServing,
      fatPerServing: data.fatPerServing.present
          ? data.fatPerServing.value
          : this.fatPerServing,
      caloriesPerServing: data.caloriesPerServing.present
          ? data.caloriesPerServing.value
          : this.caloriesPerServing,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions, ')
          ..write('favorite: $favorite, ')
          ..write('servings: $servings, ')
          ..write('carbohydratesPerServing: $carbohydratesPerServing, ')
          ..write('proteinPerServing: $proteinPerServing, ')
          ..write('fatPerServing: $fatPerServing, ')
          ..write('caloriesPerServing: $caloriesPerServing')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      instructions,
      favorite,
      servings,
      carbohydratesPerServing,
      proteinPerServing,
      fatPerServing,
      caloriesPerServing);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeData &&
          other.id == this.id &&
          other.name == this.name &&
          other.instructions == this.instructions &&
          other.favorite == this.favorite &&
          other.servings == this.servings &&
          other.carbohydratesPerServing == this.carbohydratesPerServing &&
          other.proteinPerServing == this.proteinPerServing &&
          other.fatPerServing == this.fatPerServing &&
          other.caloriesPerServing == this.caloriesPerServing);
}

class RecipesCompanion extends UpdateCompanion<RecipeData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> instructions;
  final Value<bool> favorite;
  final Value<int> servings;
  final Value<double?> carbohydratesPerServing;
  final Value<double?> proteinPerServing;
  final Value<double?> fatPerServing;
  final Value<double?> caloriesPerServing;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.instructions = const Value.absent(),
    this.favorite = const Value.absent(),
    this.servings = const Value.absent(),
    this.carbohydratesPerServing = const Value.absent(),
    this.proteinPerServing = const Value.absent(),
    this.fatPerServing = const Value.absent(),
    this.caloriesPerServing = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String instructions,
    this.favorite = const Value.absent(),
    required int servings,
    this.carbohydratesPerServing = const Value.absent(),
    this.proteinPerServing = const Value.absent(),
    this.fatPerServing = const Value.absent(),
    this.caloriesPerServing = const Value.absent(),
  })  : name = Value(name),
        instructions = Value(instructions),
        servings = Value(servings);
  static Insertable<RecipeData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? instructions,
    Expression<bool>? favorite,
    Expression<int>? servings,
    Expression<double>? carbohydratesPerServing,
    Expression<double>? proteinPerServing,
    Expression<double>? fatPerServing,
    Expression<double>? caloriesPerServing,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (instructions != null) 'instructions': instructions,
      if (favorite != null) 'favorite': favorite,
      if (servings != null) 'servings': servings,
      if (carbohydratesPerServing != null)
        'carbohydrates_per_serving': carbohydratesPerServing,
      if (proteinPerServing != null) 'protein_per_serving': proteinPerServing,
      if (fatPerServing != null) 'fat_per_serving': fatPerServing,
      if (caloriesPerServing != null)
        'calories_per_serving': caloriesPerServing,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? instructions,
      Value<bool>? favorite,
      Value<int>? servings,
      Value<double?>? carbohydratesPerServing,
      Value<double?>? proteinPerServing,
      Value<double?>? fatPerServing,
      Value<double?>? caloriesPerServing}) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      favorite: favorite ?? this.favorite,
      servings: servings ?? this.servings,
      carbohydratesPerServing:
          carbohydratesPerServing ?? this.carbohydratesPerServing,
      proteinPerServing: proteinPerServing ?? this.proteinPerServing,
      fatPerServing: fatPerServing ?? this.fatPerServing,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (carbohydratesPerServing.present) {
      map['carbohydrates_per_serving'] =
          Variable<double>(carbohydratesPerServing.value);
    }
    if (proteinPerServing.present) {
      map['protein_per_serving'] = Variable<double>(proteinPerServing.value);
    }
    if (fatPerServing.present) {
      map['fat_per_serving'] = Variable<double>(fatPerServing.value);
    }
    if (caloriesPerServing.present) {
      map['calories_per_serving'] = Variable<double>(caloriesPerServing.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions, ')
          ..write('favorite: $favorite, ')
          ..write('servings: $servings, ')
          ..write('carbohydratesPerServing: $carbohydratesPerServing, ')
          ..write('proteinPerServing: $proteinPerServing, ')
          ..write('fatPerServing: $fatPerServing, ')
          ..write('caloriesPerServing: $caloriesPerServing')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, IngredientData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPerServingMeta =
      const VerificationMeta('amountPerServing');
  @override
  late final GeneratedColumn<double> amountPerServing = GeneratedColumn<double>(
      'amount_per_serving', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES recipes (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, amountPerServing, unit, recipeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<IngredientData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_per_serving')) {
      context.handle(
          _amountPerServingMeta,
          amountPerServing.isAcceptableOrUnknown(
              data['amount_per_serving']!, _amountPerServingMeta));
    } else if (isInserting) {
      context.missing(_amountPerServingMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amountPerServing: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}amount_per_serving'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class IngredientData extends DataClass implements Insertable<IngredientData> {
  final int id;
  final String name;
  final double amountPerServing;
  final String unit;
  final int recipeId;
  const IngredientData(
      {required this.id,
      required this.name,
      required this.amountPerServing,
      required this.unit,
      required this.recipeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount_per_serving'] = Variable<double>(amountPerServing);
    map['unit'] = Variable<String>(unit);
    map['recipe_id'] = Variable<int>(recipeId);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      amountPerServing: Value(amountPerServing),
      unit: Value(unit),
      recipeId: Value(recipeId),
    );
  }

  factory IngredientData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amountPerServing: serializer.fromJson<double>(json['amountPerServing']),
      unit: serializer.fromJson<String>(json['unit']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amountPerServing': serializer.toJson<double>(amountPerServing),
      'unit': serializer.toJson<String>(unit),
      'recipeId': serializer.toJson<int>(recipeId),
    };
  }

  IngredientData copyWith(
          {int? id,
          String? name,
          double? amountPerServing,
          String? unit,
          int? recipeId}) =>
      IngredientData(
        id: id ?? this.id,
        name: name ?? this.name,
        amountPerServing: amountPerServing ?? this.amountPerServing,
        unit: unit ?? this.unit,
        recipeId: recipeId ?? this.recipeId,
      );
  IngredientData copyWithCompanion(IngredientsCompanion data) {
    return IngredientData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amountPerServing: data.amountPerServing.present
          ? data.amountPerServing.value
          : this.amountPerServing,
      unit: data.unit.present ? data.unit.value : this.unit,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountPerServing: $amountPerServing, ')
          ..write('unit: $unit, ')
          ..write('recipeId: $recipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amountPerServing, unit, recipeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientData &&
          other.id == this.id &&
          other.name == this.name &&
          other.amountPerServing == this.amountPerServing &&
          other.unit == this.unit &&
          other.recipeId == this.recipeId);
}

class IngredientsCompanion extends UpdateCompanion<IngredientData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> amountPerServing;
  final Value<String> unit;
  final Value<int> recipeId;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amountPerServing = const Value.absent(),
    this.unit = const Value.absent(),
    this.recipeId = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double amountPerServing,
    required String unit,
    required int recipeId,
  })  : name = Value(name),
        amountPerServing = Value(amountPerServing),
        unit = Value(unit),
        recipeId = Value(recipeId);
  static Insertable<IngredientData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? amountPerServing,
    Expression<String>? unit,
    Expression<int>? recipeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amountPerServing != null) 'amount_per_serving': amountPerServing,
      if (unit != null) 'unit': unit,
      if (recipeId != null) 'recipe_id': recipeId,
    });
  }

  IngredientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? amountPerServing,
      Value<String>? unit,
      Value<int>? recipeId}) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amountPerServing: amountPerServing ?? this.amountPerServing,
      unit: unit ?? this.unit,
      recipeId: recipeId ?? this.recipeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountPerServing.present) {
      map['amount_per_serving'] = Variable<double>(amountPerServing.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountPerServing: $amountPerServing, ')
          ..write('unit: $unit, ')
          ..write('recipeId: $recipeId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [recipes, ingredients];
}

typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required String name,
  required String instructions,
  Value<bool> favorite,
  required int servings,
  Value<double?> carbohydratesPerServing,
  Value<double?> proteinPerServing,
  Value<double?> fatPerServing,
  Value<double?> caloriesPerServing,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> instructions,
  Value<bool> favorite,
  Value<int> servings,
  Value<double?> carbohydratesPerServing,
  Value<double?> proteinPerServing,
  Value<double?> fatPerServing,
  Value<double?> caloriesPerServing,
});

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, RecipeData> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IngredientsTable, List<IngredientData>>
      _ingredientsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ingredients,
              aliasName:
                  $_aliasNameGenerator(db.recipes.id, db.ingredients.recipeId));

  $$IngredientsTableProcessedTableManager get ingredientsRefs {
    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbohydratesPerServing => $composableBuilder(
      column: $table.carbohydratesPerServing,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinPerServing => $composableBuilder(
      column: $table.proteinPerServing,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fatPerServing => $composableBuilder(
      column: $table.fatPerServing, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get caloriesPerServing => $composableBuilder(
      column: $table.caloriesPerServing,
      builder: (column) => ColumnFilters(column));

  Expression<bool> ingredientsRefs(
      Expression<bool> Function($$IngredientsTableFilterComposer f) f) {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbohydratesPerServing => $composableBuilder(
      column: $table.carbohydratesPerServing,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinPerServing => $composableBuilder(
      column: $table.proteinPerServing,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fatPerServing => $composableBuilder(
      column: $table.fatPerServing,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get caloriesPerServing => $composableBuilder(
      column: $table.caloriesPerServing,
      builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<double> get carbohydratesPerServing => $composableBuilder(
      column: $table.carbohydratesPerServing, builder: (column) => column);

  GeneratedColumn<double> get proteinPerServing => $composableBuilder(
      column: $table.proteinPerServing, builder: (column) => column);

  GeneratedColumn<double> get fatPerServing => $composableBuilder(
      column: $table.fatPerServing, builder: (column) => column);

  GeneratedColumn<double> get caloriesPerServing => $composableBuilder(
      column: $table.caloriesPerServing, builder: (column) => column);

  Expression<T> ingredientsRefs<T extends Object>(
      Expression<T> Function($$IngredientsTableAnnotationComposer a) f) {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTable,
    RecipeData,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (RecipeData, $$RecipesTableReferences),
    RecipeData,
    PrefetchHooks Function({bool ingredientsRefs})> {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> instructions = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<double?> carbohydratesPerServing = const Value.absent(),
            Value<double?> proteinPerServing = const Value.absent(),
            Value<double?> fatPerServing = const Value.absent(),
            Value<double?> caloriesPerServing = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            name: name,
            instructions: instructions,
            favorite: favorite,
            servings: servings,
            carbohydratesPerServing: carbohydratesPerServing,
            proteinPerServing: proteinPerServing,
            fatPerServing: fatPerServing,
            caloriesPerServing: caloriesPerServing,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String instructions,
            Value<bool> favorite = const Value.absent(),
            required int servings,
            Value<double?> carbohydratesPerServing = const Value.absent(),
            Value<double?> proteinPerServing = const Value.absent(),
            Value<double?> fatPerServing = const Value.absent(),
            Value<double?> caloriesPerServing = const Value.absent(),
          }) =>
              RecipesCompanion.insert(
            id: id,
            name: name,
            instructions: instructions,
            favorite: favorite,
            servings: servings,
            carbohydratesPerServing: carbohydratesPerServing,
            proteinPerServing: proteinPerServing,
            fatPerServing: fatPerServing,
            caloriesPerServing: caloriesPerServing,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RecipesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({ingredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ingredientsRefs) db.ingredients],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ingredientsRefs)
                    await $_getPrefetchedData<RecipeData, $RecipesTable,
                            IngredientData>(
                        currentTable: table,
                        referencedTable:
                            $$RecipesTableReferences._ingredientsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableReferences(db, table, p0)
                                .ingredientsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTable,
    RecipeData,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (RecipeData, $$RecipesTableReferences),
    RecipeData,
    PrefetchHooks Function({bool ingredientsRefs})>;
typedef $$IngredientsTableCreateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  required String name,
  required double amountPerServing,
  required String unit,
  required int recipeId,
});
typedef $$IngredientsTableUpdateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<double> amountPerServing,
  Value<String> unit,
  Value<int> recipeId,
});

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, IngredientData> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
          $_aliasNameGenerator(db.ingredients.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager($_db, $_db.recipes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountPerServing => $composableBuilder(
      column: $table.amountPerServing,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableFilterComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountPerServing => $composableBuilder(
      column: $table.amountPerServing,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableOrderingComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amountPerServing => $composableBuilder(
      column: $table.amountPerServing, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableAnnotationComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientsTable,
    IngredientData,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (IngredientData, $$IngredientsTableReferences),
    IngredientData,
    PrefetchHooks Function({bool recipeId})> {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amountPerServing = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
          }) =>
              IngredientsCompanion(
            id: id,
            name: name,
            amountPerServing: amountPerServing,
            unit: unit,
            recipeId: recipeId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double amountPerServing,
            required String unit,
            required int recipeId,
          }) =>
              IngredientsCompanion.insert(
            id: id,
            name: name,
            amountPerServing: amountPerServing,
            unit: unit,
            recipeId: recipeId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IngredientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeId,
                    referencedTable:
                        $$IngredientsTableReferences._recipeIdTable(db),
                    referencedColumn:
                        $$IngredientsTableReferences._recipeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$IngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientsTable,
    IngredientData,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (IngredientData, $$IngredientsTableReferences),
    IngredientData,
    PrefetchHooks Function({bool recipeId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
}
