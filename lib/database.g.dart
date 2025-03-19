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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE CASCADE'));
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

class $TagsTable extends Tags with TableInfo<$TagsTable, TagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<TagData> instance,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class TagData extends DataClass implements Insertable<TagData> {
  final int id;
  final String name;
  const TagData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory TagData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  TagData copyWith({int? id, String? name}) => TagData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  TagData copyWithCompanion(TagsCompanion data) {
    return TagData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagData && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<TagData> {
  final Value<int> id;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<TagData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $RecipeTagsTable extends RecipeTags
    with TableInfo<$RecipeTagsTable, RecipeTagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE CASCADE'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES tags (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [recipeId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_tags';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeTagData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId, tagId};
  @override
  RecipeTagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeTagData(
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $RecipeTagsTable createAlias(String alias) {
    return $RecipeTagsTable(attachedDatabase, alias);
  }
}

class RecipeTagData extends DataClass implements Insertable<RecipeTagData> {
  final int recipeId;
  final int tagId;
  const RecipeTagData({required this.recipeId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<int>(recipeId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  RecipeTagsCompanion toCompanion(bool nullToAbsent) {
    return RecipeTagsCompanion(
      recipeId: Value(recipeId),
      tagId: Value(tagId),
    );
  }

  factory RecipeTagData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeTagData(
      recipeId: serializer.fromJson<int>(json['recipeId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeId': serializer.toJson<int>(recipeId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  RecipeTagData copyWith({int? recipeId, int? tagId}) => RecipeTagData(
        recipeId: recipeId ?? this.recipeId,
        tagId: tagId ?? this.tagId,
      );
  RecipeTagData copyWithCompanion(RecipeTagsCompanion data) {
    return RecipeTagData(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeTagData(')
          ..write('recipeId: $recipeId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recipeId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeTagData &&
          other.recipeId == this.recipeId &&
          other.tagId == this.tagId);
}

class RecipeTagsCompanion extends UpdateCompanion<RecipeTagData> {
  final Value<int> recipeId;
  final Value<int> tagId;
  final Value<int> rowid;
  const RecipeTagsCompanion({
    this.recipeId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeTagsCompanion.insert({
    required int recipeId,
    required int tagId,
    this.rowid = const Value.absent(),
  })  : recipeId = Value(recipeId),
        tagId = Value(tagId);
  static Insertable<RecipeTagData> custom({
    Expression<int>? recipeId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeTagsCompanion copyWith(
      {Value<int>? recipeId, Value<int>? tagId, Value<int>? rowid}) {
    return RecipeTagsCompanion(
      recipeId: recipeId ?? this.recipeId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeTagsCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeImagesTable extends RecipeImages
    with TableInfo<$RecipeImagesTable, RecipeImageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, path, recipeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_images';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeImageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
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
  RecipeImageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeImageData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
    );
  }

  @override
  $RecipeImagesTable createAlias(String alias) {
    return $RecipeImagesTable(attachedDatabase, alias);
  }
}

class RecipeImageData extends DataClass implements Insertable<RecipeImageData> {
  final int id;
  final String path;
  final int recipeId;
  const RecipeImageData(
      {required this.id, required this.path, required this.recipeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['recipe_id'] = Variable<int>(recipeId);
    return map;
  }

  RecipeImagesCompanion toCompanion(bool nullToAbsent) {
    return RecipeImagesCompanion(
      id: Value(id),
      path: Value(path),
      recipeId: Value(recipeId),
    );
  }

  factory RecipeImageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeImageData(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'recipeId': serializer.toJson<int>(recipeId),
    };
  }

  RecipeImageData copyWith({int? id, String? path, int? recipeId}) =>
      RecipeImageData(
        id: id ?? this.id,
        path: path ?? this.path,
        recipeId: recipeId ?? this.recipeId,
      );
  RecipeImageData copyWithCompanion(RecipeImagesCompanion data) {
    return RecipeImageData(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeImageData(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('recipeId: $recipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, recipeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeImageData &&
          other.id == this.id &&
          other.path == this.path &&
          other.recipeId == this.recipeId);
}

class RecipeImagesCompanion extends UpdateCompanion<RecipeImageData> {
  final Value<int> id;
  final Value<String> path;
  final Value<int> recipeId;
  const RecipeImagesCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.recipeId = const Value.absent(),
  });
  RecipeImagesCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    required int recipeId,
  })  : path = Value(path),
        recipeId = Value(recipeId);
  static Insertable<RecipeImageData> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<int>? recipeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (recipeId != null) 'recipe_id': recipeId,
    });
  }

  RecipeImagesCompanion copyWith(
      {Value<int>? id, Value<String>? path, Value<int>? recipeId}) {
    return RecipeImagesCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      recipeId: recipeId ?? this.recipeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeImagesCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('recipeId: $recipeId')
          ..write(')'))
        .toString();
  }
}

class $GroceriesTable extends Groceries
    with TableInfo<$GroceriesTable, GroceryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroceriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isBoughtMeta =
      const VerificationMeta('isBought');
  @override
  late final GeneratedColumn<bool> isBought = GeneratedColumn<bool>(
      'is_bought', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_bought" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _listOrderMeta =
      const VerificationMeta('listOrder');
  @override
  late final GeneratedColumn<int> listOrder = GeneratedColumn<int>(
      'list_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, amount, unit, isBought, listOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groceries';
  @override
  VerificationContext validateIntegrity(Insertable<GroceryData> instance,
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
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('is_bought')) {
      context.handle(_isBoughtMeta,
          isBought.isAcceptableOrUnknown(data['is_bought']!, _isBoughtMeta));
    }
    if (data.containsKey('list_order')) {
      context.handle(_listOrderMeta,
          listOrder.isAcceptableOrUnknown(data['list_order']!, _listOrderMeta));
    } else if (isInserting) {
      context.missing(_listOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroceryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroceryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      isBought: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bought'])!,
      listOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}list_order'])!,
    );
  }

  @override
  $GroceriesTable createAlias(String alias) {
    return $GroceriesTable(attachedDatabase, alias);
  }
}

class GroceryData extends DataClass implements Insertable<GroceryData> {
  final int id;
  final String name;
  final double amount;
  final String unit;
  final bool isBought;
  final int listOrder;
  const GroceryData(
      {required this.id,
      required this.name,
      required this.amount,
      required this.unit,
      required this.isBought,
      required this.listOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['unit'] = Variable<String>(unit);
    map['is_bought'] = Variable<bool>(isBought);
    map['list_order'] = Variable<int>(listOrder);
    return map;
  }

  GroceriesCompanion toCompanion(bool nullToAbsent) {
    return GroceriesCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      unit: Value(unit),
      isBought: Value(isBought),
      listOrder: Value(listOrder),
    );
  }

  factory GroceryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroceryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
      isBought: serializer.fromJson<bool>(json['isBought']),
      listOrder: serializer.fromJson<int>(json['listOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(unit),
      'isBought': serializer.toJson<bool>(isBought),
      'listOrder': serializer.toJson<int>(listOrder),
    };
  }

  GroceryData copyWith(
          {int? id,
          String? name,
          double? amount,
          String? unit,
          bool? isBought,
          int? listOrder}) =>
      GroceryData(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
        isBought: isBought ?? this.isBought,
        listOrder: listOrder ?? this.listOrder,
      );
  GroceryData copyWithCompanion(GroceriesCompanion data) {
    return GroceryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      isBought: data.isBought.present ? data.isBought.value : this.isBought,
      listOrder: data.listOrder.present ? data.listOrder.value : this.listOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroceryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('isBought: $isBought, ')
          ..write('listOrder: $listOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, unit, isBought, listOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroceryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.isBought == this.isBought &&
          other.listOrder == this.listOrder);
}

class GroceriesCompanion extends UpdateCompanion<GroceryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> unit;
  final Value<bool> isBought;
  final Value<int> listOrder;
  const GroceriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.isBought = const Value.absent(),
    this.listOrder = const Value.absent(),
  });
  GroceriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double amount,
    required String unit,
    this.isBought = const Value.absent(),
    required int listOrder,
  })  : name = Value(name),
        amount = Value(amount),
        unit = Value(unit),
        listOrder = Value(listOrder);
  static Insertable<GroceryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<bool>? isBought,
    Expression<int>? listOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (isBought != null) 'is_bought': isBought,
      if (listOrder != null) 'list_order': listOrder,
    });
  }

  GroceriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<String>? unit,
      Value<bool>? isBought,
      Value<int>? listOrder}) {
    return GroceriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      isBought: isBought ?? this.isBought,
      listOrder: listOrder ?? this.listOrder,
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
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isBought.present) {
      map['is_bought'] = Variable<bool>(isBought.value);
    }
    if (listOrder.present) {
      map['list_order'] = Variable<int>(listOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroceriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('isBought: $isBought, ')
          ..write('listOrder: $listOrder')
          ..write(')'))
        .toString();
  }
}

class $MealPlansTable extends MealPlans
    with TableInfo<$MealPlansTable, MealPlanData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _servingsPerMealMeta =
      const VerificationMeta('servingsPerMeal');
  @override
  late final GeneratedColumn<int> servingsPerMeal = GeneratedColumn<int>(
      'servings_per_meal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, servingsPerMeal];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plans';
  @override
  VerificationContext validateIntegrity(Insertable<MealPlanData> instance,
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
    if (data.containsKey('servings_per_meal')) {
      context.handle(
          _servingsPerMealMeta,
          servingsPerMeal.isAcceptableOrUnknown(
              data['servings_per_meal']!, _servingsPerMealMeta));
    } else if (isInserting) {
      context.missing(_servingsPerMealMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      servingsPerMeal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings_per_meal'])!,
    );
  }

  @override
  $MealPlansTable createAlias(String alias) {
    return $MealPlansTable(attachedDatabase, alias);
  }
}

class MealPlanData extends DataClass implements Insertable<MealPlanData> {
  final int id;
  final String name;
  final int servingsPerMeal;
  const MealPlanData(
      {required this.id, required this.name, required this.servingsPerMeal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['servings_per_meal'] = Variable<int>(servingsPerMeal);
    return map;
  }

  MealPlansCompanion toCompanion(bool nullToAbsent) {
    return MealPlansCompanion(
      id: Value(id),
      name: Value(name),
      servingsPerMeal: Value(servingsPerMeal),
    );
  }

  factory MealPlanData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      servingsPerMeal: serializer.fromJson<int>(json['servingsPerMeal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'servingsPerMeal': serializer.toJson<int>(servingsPerMeal),
    };
  }

  MealPlanData copyWith({int? id, String? name, int? servingsPerMeal}) =>
      MealPlanData(
        id: id ?? this.id,
        name: name ?? this.name,
        servingsPerMeal: servingsPerMeal ?? this.servingsPerMeal,
      );
  MealPlanData copyWithCompanion(MealPlansCompanion data) {
    return MealPlanData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      servingsPerMeal: data.servingsPerMeal.present
          ? data.servingsPerMeal.value
          : this.servingsPerMeal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('servingsPerMeal: $servingsPerMeal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, servingsPerMeal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanData &&
          other.id == this.id &&
          other.name == this.name &&
          other.servingsPerMeal == this.servingsPerMeal);
}

class MealPlansCompanion extends UpdateCompanion<MealPlanData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> servingsPerMeal;
  const MealPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.servingsPerMeal = const Value.absent(),
  });
  MealPlansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int servingsPerMeal,
  })  : name = Value(name),
        servingsPerMeal = Value(servingsPerMeal);
  static Insertable<MealPlanData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? servingsPerMeal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (servingsPerMeal != null) 'servings_per_meal': servingsPerMeal,
    });
  }

  MealPlansCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? servingsPerMeal}) {
    return MealPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      servingsPerMeal: servingsPerMeal ?? this.servingsPerMeal,
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
    if (servingsPerMeal.present) {
      map['servings_per_meal'] = Variable<int>(servingsPerMeal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('servingsPerMeal: $servingsPerMeal')
          ..write(')'))
        .toString();
  }
}

class $DaysTable extends Days with TableInfo<$DaysTable, DayData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DaysTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _mealPlanIdMeta =
      const VerificationMeta('mealPlanId');
  @override
  late final GeneratedColumn<int> mealPlanId = GeneratedColumn<int>(
      'meal_plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meal_plans (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, name, mealPlanId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'days';
  @override
  VerificationContext validateIntegrity(Insertable<DayData> instance,
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
    if (data.containsKey('meal_plan_id')) {
      context.handle(
          _mealPlanIdMeta,
          mealPlanId.isAcceptableOrUnknown(
              data['meal_plan_id']!, _mealPlanIdMeta));
    } else if (isInserting) {
      context.missing(_mealPlanIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mealPlanId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_plan_id'])!,
    );
  }

  @override
  $DaysTable createAlias(String alias) {
    return $DaysTable(attachedDatabase, alias);
  }
}

class DayData extends DataClass implements Insertable<DayData> {
  final int id;
  final String name;
  final int mealPlanId;
  const DayData(
      {required this.id, required this.name, required this.mealPlanId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['meal_plan_id'] = Variable<int>(mealPlanId);
    return map;
  }

  DaysCompanion toCompanion(bool nullToAbsent) {
    return DaysCompanion(
      id: Value(id),
      name: Value(name),
      mealPlanId: Value(mealPlanId),
    );
  }

  factory DayData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mealPlanId: serializer.fromJson<int>(json['mealPlanId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'mealPlanId': serializer.toJson<int>(mealPlanId),
    };
  }

  DayData copyWith({int? id, String? name, int? mealPlanId}) => DayData(
        id: id ?? this.id,
        name: name ?? this.name,
        mealPlanId: mealPlanId ?? this.mealPlanId,
      );
  DayData copyWithCompanion(DaysCompanion data) {
    return DayData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mealPlanId:
          data.mealPlanId.present ? data.mealPlanId.value : this.mealPlanId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mealPlanId: $mealPlanId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, mealPlanId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayData &&
          other.id == this.id &&
          other.name == this.name &&
          other.mealPlanId == this.mealPlanId);
}

class DaysCompanion extends UpdateCompanion<DayData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> mealPlanId;
  const DaysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mealPlanId = const Value.absent(),
  });
  DaysCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int mealPlanId,
  })  : name = Value(name),
        mealPlanId = Value(mealPlanId);
  static Insertable<DayData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? mealPlanId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mealPlanId != null) 'meal_plan_id': mealPlanId,
    });
  }

  DaysCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? mealPlanId}) {
    return DaysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mealPlanId: mealPlanId ?? this.mealPlanId,
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
    if (mealPlanId.present) {
      map['meal_plan_id'] = Variable<int>(mealPlanId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DaysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mealPlanId: $mealPlanId')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, MealData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<int> dayId = GeneratedColumn<int>(
      'day_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES days (id) ON DELETE CASCADE'));
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, name, dayId, recipeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(Insertable<MealData> instance,
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
    if (data.containsKey('day_id')) {
      context.handle(
          _dayIdMeta, dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta));
    } else if (isInserting) {
      context.missing(_dayIdMeta);
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
  MealData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dayId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class MealData extends DataClass implements Insertable<MealData> {
  final int id;
  final String name;
  final int dayId;
  final int recipeId;
  const MealData(
      {required this.id,
      required this.name,
      required this.dayId,
      required this.recipeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['day_id'] = Variable<int>(dayId);
    map['recipe_id'] = Variable<int>(recipeId);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      name: Value(name),
      dayId: Value(dayId),
      recipeId: Value(recipeId),
    );
  }

  factory MealData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dayId: serializer.fromJson<int>(json['dayId']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dayId': serializer.toJson<int>(dayId),
      'recipeId': serializer.toJson<int>(recipeId),
    };
  }

  MealData copyWith({int? id, String? name, int? dayId, int? recipeId}) =>
      MealData(
        id: id ?? this.id,
        name: name ?? this.name,
        dayId: dayId ?? this.dayId,
        recipeId: recipeId ?? this.recipeId,
      );
  MealData copyWithCompanion(MealsCompanion data) {
    return MealData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dayId: $dayId, ')
          ..write('recipeId: $recipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, dayId, recipeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealData &&
          other.id == this.id &&
          other.name == this.name &&
          other.dayId == this.dayId &&
          other.recipeId == this.recipeId);
}

class MealsCompanion extends UpdateCompanion<MealData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> dayId;
  final Value<int> recipeId;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dayId = const Value.absent(),
    this.recipeId = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int dayId,
    required int recipeId,
  })  : name = Value(name),
        dayId = Value(dayId),
        recipeId = Value(recipeId);
  static Insertable<MealData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? dayId,
    Expression<int>? recipeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dayId != null) 'day_id': dayId,
      if (recipeId != null) 'recipe_id': recipeId,
    });
  }

  MealsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? dayId,
      Value<int>? recipeId}) {
    return MealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dayId: dayId ?? this.dayId,
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
    if (dayId.present) {
      map['day_id'] = Variable<int>(dayId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dayId: $dayId, ')
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
  late final $TagsTable tags = $TagsTable(this);
  late final $RecipeTagsTable recipeTags = $RecipeTagsTable(this);
  late final $RecipeImagesTable recipeImages = $RecipeImagesTable(this);
  late final $GroceriesTable groceries = $GroceriesTable(this);
  late final $MealPlansTable mealPlans = $MealPlansTable(this);
  late final $DaysTable days = $DaysTable(this);
  late final $MealsTable meals = $MealsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        recipes,
        ingredients,
        tags,
        recipeTags,
        recipeImages,
        groceries,
        mealPlans,
        days,
        meals
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('ingredients', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('tags',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_images', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('meal_plans',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('days', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('days',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meals', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meals', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
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

  static MultiTypedResultKey<$RecipeTagsTable, List<RecipeTagData>>
      _recipeTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recipeTags,
              aliasName:
                  $_aliasNameGenerator(db.recipes.id, db.recipeTags.recipeId));

  $$RecipeTagsTableProcessedTableManager get recipeTagsRefs {
    final manager = $$RecipeTagsTableTableManager($_db, $_db.recipeTags)
        .filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RecipeImagesTable, List<RecipeImageData>>
      _recipeImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.recipeImages,
          aliasName:
              $_aliasNameGenerator(db.recipes.id, db.recipeImages.recipeId));

  $$RecipeImagesTableProcessedTableManager get recipeImagesRefs {
    final manager = $$RecipeImagesTableTableManager($_db, $_db.recipeImages)
        .filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeImagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MealsTable, List<MealData>> _mealsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.meals,
          aliasName: $_aliasNameGenerator(db.recipes.id, db.meals.recipeId));

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager($_db, $_db.meals)
        .filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
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

  Expression<bool> recipeTagsRefs(
      Expression<bool> Function($$RecipeTagsTableFilterComposer f) f) {
    final $$RecipeTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeTags,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeTagsTableFilterComposer(
              $db: $db,
              $table: $db.recipeTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> recipeImagesRefs(
      Expression<bool> Function($$RecipeImagesTableFilterComposer f) f) {
    final $$RecipeImagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeImages,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeImagesTableFilterComposer(
              $db: $db,
              $table: $db.recipeImages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mealsRefs(
      Expression<bool> Function($$MealsTableFilterComposer f) f) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableFilterComposer(
              $db: $db,
              $table: $db.meals,
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

  Expression<T> recipeTagsRefs<T extends Object>(
      Expression<T> Function($$RecipeTagsTableAnnotationComposer a) f) {
    final $$RecipeTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeTags,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.recipeTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> recipeImagesRefs<T extends Object>(
      Expression<T> Function($$RecipeImagesTableAnnotationComposer a) f) {
    final $$RecipeImagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeImages,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeImagesTableAnnotationComposer(
              $db: $db,
              $table: $db.recipeImages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> mealsRefs<T extends Object>(
      Expression<T> Function($$MealsTableAnnotationComposer a) f) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableAnnotationComposer(
              $db: $db,
              $table: $db.meals,
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
    PrefetchHooks Function(
        {bool ingredientsRefs,
        bool recipeTagsRefs,
        bool recipeImagesRefs,
        bool mealsRefs})> {
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
          prefetchHooksCallback: (
              {ingredientsRefs = false,
              recipeTagsRefs = false,
              recipeImagesRefs = false,
              mealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ingredientsRefs) db.ingredients,
                if (recipeTagsRefs) db.recipeTags,
                if (recipeImagesRefs) db.recipeImages,
                if (mealsRefs) db.meals
              ],
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
                        typedResults: items),
                  if (recipeTagsRefs)
                    await $_getPrefetchedData<RecipeData, $RecipesTable,
                            RecipeTagData>(
                        currentTable: table,
                        referencedTable:
                            $$RecipesTableReferences._recipeTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableReferences(db, table, p0)
                                .recipeTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items),
                  if (recipeImagesRefs)
                    await $_getPrefetchedData<RecipeData, $RecipesTable,
                            RecipeImageData>(
                        currentTable: table,
                        referencedTable:
                            $$RecipesTableReferences._recipeImagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableReferences(db, table, p0)
                                .recipeImagesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items),
                  if (mealsRefs)
                    await $_getPrefetchedData<RecipeData, $RecipesTable,
                            MealData>(
                        currentTable: table,
                        referencedTable:
                            $$RecipesTableReferences._mealsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableReferences(db, table, p0).mealsRefs,
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
    PrefetchHooks Function(
        {bool ingredientsRefs,
        bool recipeTagsRefs,
        bool recipeImagesRefs,
        bool mealsRefs})>;
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
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, TagData> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeTagsTable, List<RecipeTagData>>
      _recipeTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recipeTags,
              aliasName: $_aliasNameGenerator(db.tags.id, db.recipeTags.tagId));

  $$RecipeTagsTableProcessedTableManager get recipeTagsRefs {
    final manager = $$RecipeTagsTableTableManager($_db, $_db.recipeTags)
        .filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
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

  Expression<bool> recipeTagsRefs(
      Expression<bool> Function($$RecipeTagsTableFilterComposer f) f) {
    final $$RecipeTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeTagsTableFilterComposer(
              $db: $db,
              $table: $db.recipeTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
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
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
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

  Expression<T> recipeTagsRefs<T extends Object>(
      Expression<T> Function($$RecipeTagsTableAnnotationComposer a) f) {
    final $$RecipeTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.recipeTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    TagData,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (TagData, $$TagsTableReferences),
    TagData,
    PrefetchHooks Function({bool recipeTagsRefs})> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TagsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({recipeTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (recipeTagsRefs) db.recipeTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeTagsRefs)
                    await $_getPrefetchedData<TagData, $TagsTable,
                            RecipeTagData>(
                        currentTable: table,
                        referencedTable:
                            $$TagsTableReferences._recipeTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TagsTableReferences(db, table, p0).recipeTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tagId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTable,
    TagData,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (TagData, $$TagsTableReferences),
    TagData,
    PrefetchHooks Function({bool recipeTagsRefs})>;
typedef $$RecipeTagsTableCreateCompanionBuilder = RecipeTagsCompanion Function({
  required int recipeId,
  required int tagId,
  Value<int> rowid,
});
typedef $$RecipeTagsTableUpdateCompanionBuilder = RecipeTagsCompanion Function({
  Value<int> recipeId,
  Value<int> tagId,
  Value<int> rowid,
});

final class $$RecipeTagsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeTagsTable, RecipeTagData> {
  $$RecipeTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) => db.recipes
      .createAlias($_aliasNameGenerator(db.recipeTags.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager($_db, $_db.recipes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags
      .createAlias($_aliasNameGenerator(db.recipeTags.tagId, db.tags.id));

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager($_db, $_db.tags)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecipeTagsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeTagsTable> {
  $$RecipeTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableFilterComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeTagsTable> {
  $$RecipeTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableOrderingComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeTagsTable> {
  $$RecipeTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableAnnotationComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipeTagsTable,
    RecipeTagData,
    $$RecipeTagsTableFilterComposer,
    $$RecipeTagsTableOrderingComposer,
    $$RecipeTagsTableAnnotationComposer,
    $$RecipeTagsTableCreateCompanionBuilder,
    $$RecipeTagsTableUpdateCompanionBuilder,
    (RecipeTagData, $$RecipeTagsTableReferences),
    RecipeTagData,
    PrefetchHooks Function({bool recipeId, bool tagId})> {
  $$RecipeTagsTableTableManager(_$AppDatabase db, $RecipeTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> recipeId = const Value.absent(),
            Value<int> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeTagsCompanion(
            recipeId: recipeId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int recipeId,
            required int tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeTagsCompanion.insert(
            recipeId: recipeId,
            tagId: tagId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecipeTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recipeId = false, tagId = false}) {
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
                        $$RecipeTagsTableReferences._recipeIdTable(db),
                    referencedColumn:
                        $$RecipeTagsTableReferences._recipeIdTable(db).id,
                  ) as T;
                }
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable:
                        $$RecipeTagsTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$RecipeTagsTableReferences._tagIdTable(db).id,
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

typedef $$RecipeTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipeTagsTable,
    RecipeTagData,
    $$RecipeTagsTableFilterComposer,
    $$RecipeTagsTableOrderingComposer,
    $$RecipeTagsTableAnnotationComposer,
    $$RecipeTagsTableCreateCompanionBuilder,
    $$RecipeTagsTableUpdateCompanionBuilder,
    (RecipeTagData, $$RecipeTagsTableReferences),
    RecipeTagData,
    PrefetchHooks Function({bool recipeId, bool tagId})>;
typedef $$RecipeImagesTableCreateCompanionBuilder = RecipeImagesCompanion
    Function({
  Value<int> id,
  required String path,
  required int recipeId,
});
typedef $$RecipeImagesTableUpdateCompanionBuilder = RecipeImagesCompanion
    Function({
  Value<int> id,
  Value<String> path,
  Value<int> recipeId,
});

final class $$RecipeImagesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeImagesTable, RecipeImageData> {
  $$RecipeImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
          $_aliasNameGenerator(db.recipeImages.recipeId, db.recipes.id));

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

class $$RecipeImagesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeImagesTable> {
  $$RecipeImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

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

class $$RecipeImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeImagesTable> {
  $$RecipeImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

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

class $$RecipeImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeImagesTable> {
  $$RecipeImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

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

class $$RecipeImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipeImagesTable,
    RecipeImageData,
    $$RecipeImagesTableFilterComposer,
    $$RecipeImagesTableOrderingComposer,
    $$RecipeImagesTableAnnotationComposer,
    $$RecipeImagesTableCreateCompanionBuilder,
    $$RecipeImagesTableUpdateCompanionBuilder,
    (RecipeImageData, $$RecipeImagesTableReferences),
    RecipeImageData,
    PrefetchHooks Function({bool recipeId})> {
  $$RecipeImagesTableTableManager(_$AppDatabase db, $RecipeImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
          }) =>
              RecipeImagesCompanion(
            id: id,
            path: path,
            recipeId: recipeId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String path,
            required int recipeId,
          }) =>
              RecipeImagesCompanion.insert(
            id: id,
            path: path,
            recipeId: recipeId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecipeImagesTableReferences(db, table, e)
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
                        $$RecipeImagesTableReferences._recipeIdTable(db),
                    referencedColumn:
                        $$RecipeImagesTableReferences._recipeIdTable(db).id,
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

typedef $$RecipeImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipeImagesTable,
    RecipeImageData,
    $$RecipeImagesTableFilterComposer,
    $$RecipeImagesTableOrderingComposer,
    $$RecipeImagesTableAnnotationComposer,
    $$RecipeImagesTableCreateCompanionBuilder,
    $$RecipeImagesTableUpdateCompanionBuilder,
    (RecipeImageData, $$RecipeImagesTableReferences),
    RecipeImageData,
    PrefetchHooks Function({bool recipeId})>;
typedef $$GroceriesTableCreateCompanionBuilder = GroceriesCompanion Function({
  Value<int> id,
  required String name,
  required double amount,
  required String unit,
  Value<bool> isBought,
  required int listOrder,
});
typedef $$GroceriesTableUpdateCompanionBuilder = GroceriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> amount,
  Value<String> unit,
  Value<bool> isBought,
  Value<int> listOrder,
});

class $$GroceriesTableFilterComposer
    extends Composer<_$AppDatabase, $GroceriesTable> {
  $$GroceriesTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBought => $composableBuilder(
      column: $table.isBought, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get listOrder => $composableBuilder(
      column: $table.listOrder, builder: (column) => ColumnFilters(column));
}

class $$GroceriesTableOrderingComposer
    extends Composer<_$AppDatabase, $GroceriesTable> {
  $$GroceriesTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBought => $composableBuilder(
      column: $table.isBought, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get listOrder => $composableBuilder(
      column: $table.listOrder, builder: (column) => ColumnOrderings(column));
}

class $$GroceriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroceriesTable> {
  $$GroceriesTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isBought =>
      $composableBuilder(column: $table.isBought, builder: (column) => column);

  GeneratedColumn<int> get listOrder =>
      $composableBuilder(column: $table.listOrder, builder: (column) => column);
}

class $$GroceriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroceriesTable,
    GroceryData,
    $$GroceriesTableFilterComposer,
    $$GroceriesTableOrderingComposer,
    $$GroceriesTableAnnotationComposer,
    $$GroceriesTableCreateCompanionBuilder,
    $$GroceriesTableUpdateCompanionBuilder,
    (GroceryData, BaseReferences<_$AppDatabase, $GroceriesTable, GroceryData>),
    GroceryData,
    PrefetchHooks Function()> {
  $$GroceriesTableTableManager(_$AppDatabase db, $GroceriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroceriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroceriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroceriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<bool> isBought = const Value.absent(),
            Value<int> listOrder = const Value.absent(),
          }) =>
              GroceriesCompanion(
            id: id,
            name: name,
            amount: amount,
            unit: unit,
            isBought: isBought,
            listOrder: listOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double amount,
            required String unit,
            Value<bool> isBought = const Value.absent(),
            required int listOrder,
          }) =>
              GroceriesCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            unit: unit,
            isBought: isBought,
            listOrder: listOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GroceriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroceriesTable,
    GroceryData,
    $$GroceriesTableFilterComposer,
    $$GroceriesTableOrderingComposer,
    $$GroceriesTableAnnotationComposer,
    $$GroceriesTableCreateCompanionBuilder,
    $$GroceriesTableUpdateCompanionBuilder,
    (GroceryData, BaseReferences<_$AppDatabase, $GroceriesTable, GroceryData>),
    GroceryData,
    PrefetchHooks Function()>;
typedef $$MealPlansTableCreateCompanionBuilder = MealPlansCompanion Function({
  Value<int> id,
  required String name,
  required int servingsPerMeal,
});
typedef $$MealPlansTableUpdateCompanionBuilder = MealPlansCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> servingsPerMeal,
});

final class $$MealPlansTableReferences
    extends BaseReferences<_$AppDatabase, $MealPlansTable, MealPlanData> {
  $$MealPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DaysTable, List<DayData>> _daysRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.days,
          aliasName: $_aliasNameGenerator(db.mealPlans.id, db.days.mealPlanId));

  $$DaysTableProcessedTableManager get daysRefs {
    final manager = $$DaysTableTableManager($_db, $_db.days)
        .filter((f) => f.mealPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_daysRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MealPlansTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableFilterComposer({
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

  ColumnFilters<int> get servingsPerMeal => $composableBuilder(
      column: $table.servingsPerMeal,
      builder: (column) => ColumnFilters(column));

  Expression<bool> daysRefs(
      Expression<bool> Function($$DaysTableFilterComposer f) f) {
    final $$DaysTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.days,
        getReferencedColumn: (t) => t.mealPlanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DaysTableFilterComposer(
              $db: $db,
              $table: $db.days,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MealPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableOrderingComposer({
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

  ColumnOrderings<int> get servingsPerMeal => $composableBuilder(
      column: $table.servingsPerMeal,
      builder: (column) => ColumnOrderings(column));
}

class $$MealPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableAnnotationComposer({
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

  GeneratedColumn<int> get servingsPerMeal => $composableBuilder(
      column: $table.servingsPerMeal, builder: (column) => column);

  Expression<T> daysRefs<T extends Object>(
      Expression<T> Function($$DaysTableAnnotationComposer a) f) {
    final $$DaysTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.days,
        getReferencedColumn: (t) => t.mealPlanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DaysTableAnnotationComposer(
              $db: $db,
              $table: $db.days,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MealPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealPlansTable,
    MealPlanData,
    $$MealPlansTableFilterComposer,
    $$MealPlansTableOrderingComposer,
    $$MealPlansTableAnnotationComposer,
    $$MealPlansTableCreateCompanionBuilder,
    $$MealPlansTableUpdateCompanionBuilder,
    (MealPlanData, $$MealPlansTableReferences),
    MealPlanData,
    PrefetchHooks Function({bool daysRefs})> {
  $$MealPlansTableTableManager(_$AppDatabase db, $MealPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> servingsPerMeal = const Value.absent(),
          }) =>
              MealPlansCompanion(
            id: id,
            name: name,
            servingsPerMeal: servingsPerMeal,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int servingsPerMeal,
          }) =>
              MealPlansCompanion.insert(
            id: id,
            name: name,
            servingsPerMeal: servingsPerMeal,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MealPlansTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({daysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (daysRefs) db.days],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (daysRefs)
                    await $_getPrefetchedData<MealPlanData, $MealPlansTable,
                            DayData>(
                        currentTable: table,
                        referencedTable:
                            $$MealPlansTableReferences._daysRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MealPlansTableReferences(db, table, p0).daysRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.mealPlanId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MealPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealPlansTable,
    MealPlanData,
    $$MealPlansTableFilterComposer,
    $$MealPlansTableOrderingComposer,
    $$MealPlansTableAnnotationComposer,
    $$MealPlansTableCreateCompanionBuilder,
    $$MealPlansTableUpdateCompanionBuilder,
    (MealPlanData, $$MealPlansTableReferences),
    MealPlanData,
    PrefetchHooks Function({bool daysRefs})>;
typedef $$DaysTableCreateCompanionBuilder = DaysCompanion Function({
  Value<int> id,
  required String name,
  required int mealPlanId,
});
typedef $$DaysTableUpdateCompanionBuilder = DaysCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> mealPlanId,
});

final class $$DaysTableReferences
    extends BaseReferences<_$AppDatabase, $DaysTable, DayData> {
  $$DaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealPlansTable _mealPlanIdTable(_$AppDatabase db) => db.mealPlans
      .createAlias($_aliasNameGenerator(db.days.mealPlanId, db.mealPlans.id));

  $$MealPlansTableProcessedTableManager get mealPlanId {
    final $_column = $_itemColumn<int>('meal_plan_id')!;

    final manager = $$MealPlansTableTableManager($_db, $_db.mealPlans)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MealsTable, List<MealData>> _mealsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.meals,
          aliasName: $_aliasNameGenerator(db.days.id, db.meals.dayId));

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager($_db, $_db.meals)
        .filter((f) => f.dayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DaysTableFilterComposer extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableFilterComposer({
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

  $$MealPlansTableFilterComposer get mealPlanId {
    final $$MealPlansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealPlanId,
        referencedTable: $db.mealPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealPlansTableFilterComposer(
              $db: $db,
              $table: $db.mealPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> mealsRefs(
      Expression<bool> Function($$MealsTableFilterComposer f) f) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.dayId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableFilterComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DaysTableOrderingComposer extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableOrderingComposer({
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

  $$MealPlansTableOrderingComposer get mealPlanId {
    final $$MealPlansTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealPlanId,
        referencedTable: $db.mealPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealPlansTableOrderingComposer(
              $db: $db,
              $table: $db.mealPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableAnnotationComposer({
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

  $$MealPlansTableAnnotationComposer get mealPlanId {
    final $$MealPlansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealPlanId,
        referencedTable: $db.mealPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealPlansTableAnnotationComposer(
              $db: $db,
              $table: $db.mealPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> mealsRefs<T extends Object>(
      Expression<T> Function($$MealsTableAnnotationComposer a) f) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.dayId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableAnnotationComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DaysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DaysTable,
    DayData,
    $$DaysTableFilterComposer,
    $$DaysTableOrderingComposer,
    $$DaysTableAnnotationComposer,
    $$DaysTableCreateCompanionBuilder,
    $$DaysTableUpdateCompanionBuilder,
    (DayData, $$DaysTableReferences),
    DayData,
    PrefetchHooks Function({bool mealPlanId, bool mealsRefs})> {
  $$DaysTableTableManager(_$AppDatabase db, $DaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> mealPlanId = const Value.absent(),
          }) =>
              DaysCompanion(
            id: id,
            name: name,
            mealPlanId: mealPlanId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int mealPlanId,
          }) =>
              DaysCompanion.insert(
            id: id,
            name: name,
            mealPlanId: mealPlanId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DaysTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mealPlanId = false, mealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealsRefs) db.meals],
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
                if (mealPlanId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mealPlanId,
                    referencedTable: $$DaysTableReferences._mealPlanIdTable(db),
                    referencedColumn:
                        $$DaysTableReferences._mealPlanIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealsRefs)
                    await $_getPrefetchedData<DayData, $DaysTable, MealData>(
                        currentTable: table,
                        referencedTable:
                            $$DaysTableReferences._mealsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DaysTableReferences(db, table, p0).mealsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.dayId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DaysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DaysTable,
    DayData,
    $$DaysTableFilterComposer,
    $$DaysTableOrderingComposer,
    $$DaysTableAnnotationComposer,
    $$DaysTableCreateCompanionBuilder,
    $$DaysTableUpdateCompanionBuilder,
    (DayData, $$DaysTableReferences),
    DayData,
    PrefetchHooks Function({bool mealPlanId, bool mealsRefs})>;
typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  required String name,
  required int dayId,
  required int recipeId,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> dayId,
  Value<int> recipeId,
});

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, MealData> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DaysTable _dayIdTable(_$AppDatabase db) =>
      db.days.createAlias($_aliasNameGenerator(db.meals.dayId, db.days.id));

  $$DaysTableProcessedTableManager get dayId {
    final $_column = $_itemColumn<int>('day_id')!;

    final manager = $$DaysTableTableManager($_db, $_db.days)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RecipesTable _recipeIdTable(_$AppDatabase db) => db.recipes
      .createAlias($_aliasNameGenerator(db.meals.recipeId, db.recipes.id));

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

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
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

  $$DaysTableFilterComposer get dayId {
    final $$DaysTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayId,
        referencedTable: $db.days,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DaysTableFilterComposer(
              $db: $db,
              $table: $db.days,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

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

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
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

  $$DaysTableOrderingComposer get dayId {
    final $$DaysTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayId,
        referencedTable: $db.days,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DaysTableOrderingComposer(
              $db: $db,
              $table: $db.days,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

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

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
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

  $$DaysTableAnnotationComposer get dayId {
    final $$DaysTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayId,
        referencedTable: $db.days,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DaysTableAnnotationComposer(
              $db: $db,
              $table: $db.days,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

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

class $$MealsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealsTable,
    MealData,
    $$MealsTableFilterComposer,
    $$MealsTableOrderingComposer,
    $$MealsTableAnnotationComposer,
    $$MealsTableCreateCompanionBuilder,
    $$MealsTableUpdateCompanionBuilder,
    (MealData, $$MealsTableReferences),
    MealData,
    PrefetchHooks Function({bool dayId, bool recipeId})> {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> dayId = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
          }) =>
              MealsCompanion(
            id: id,
            name: name,
            dayId: dayId,
            recipeId: recipeId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int dayId,
            required int recipeId,
          }) =>
              MealsCompanion.insert(
            id: id,
            name: name,
            dayId: dayId,
            recipeId: recipeId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MealsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({dayId = false, recipeId = false}) {
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
                if (dayId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dayId,
                    referencedTable: $$MealsTableReferences._dayIdTable(db),
                    referencedColumn: $$MealsTableReferences._dayIdTable(db).id,
                  ) as T;
                }
                if (recipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeId,
                    referencedTable: $$MealsTableReferences._recipeIdTable(db),
                    referencedColumn:
                        $$MealsTableReferences._recipeIdTable(db).id,
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

typedef $$MealsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealsTable,
    MealData,
    $$MealsTableFilterComposer,
    $$MealsTableOrderingComposer,
    $$MealsTableAnnotationComposer,
    $$MealsTableCreateCompanionBuilder,
    $$MealsTableUpdateCompanionBuilder,
    (MealData, $$MealsTableReferences),
    MealData,
    PrefetchHooks Function({bool dayId, bool recipeId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$RecipeTagsTableTableManager get recipeTags =>
      $$RecipeTagsTableTableManager(_db, _db.recipeTags);
  $$RecipeImagesTableTableManager get recipeImages =>
      $$RecipeImagesTableTableManager(_db, _db.recipeImages);
  $$GroceriesTableTableManager get groceries =>
      $$GroceriesTableTableManager(_db, _db.groceries);
  $$MealPlansTableTableManager get mealPlans =>
      $$MealPlansTableTableManager(_db, _db.mealPlans);
  $$DaysTableTableManager get days => $$DaysTableTableManager(_db, _db.days);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
}
