import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:recipes/database/daos/recipes_dao.dart';
import 'package:recipes/database/daos/ingredients_dao.dart';
import 'package:recipes/database/daos/tags_dao.dart';
import 'package:recipes/database/daos/groceries_dao.dart';
import 'package:recipes/database/daos/meal_plans_dao.dart';

part 'database.g.dart';

// Has limited recipe data, tags and image path.
class RecipeListItemData {
  final RecipeData recipe;
  final List<TagData> tags;
  final RecipeImageData image;

  RecipeListItemData(this.recipe, this.tags, this.image);
}

@DataClassName('RecipeData')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get instructions => text()();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  IntColumn get servings => integer()();
  RealColumn get carbohydratesPerServing => real().nullable()();
  RealColumn get proteinPerServing => real().nullable()();
  RealColumn get fatPerServing => real().nullable()();
  RealColumn get caloriesPerServing => real().nullable()();
}

@DataClassName('IngredientData')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get amountPerServing => real()();
  TextColumn get unit => text()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
}

@DataClassName('TagData')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('RecipeTagData')
class RecipeTags extends Table {
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {recipeId, tagId};
}

@DataClassName('RecipeImageData')
class RecipeImages extends Table {
  TextColumn get path => text()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {path};
}

@DataClassName('GroceryData')
class Groceries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
  BoolColumn get isBought => boolean().withDefault(const Constant(false))();
  IntColumn get listOrder => integer()();
}

@DataClassName('MealPlanData')
class MealPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get servingsPerMeal => integer()();
}

@DataClassName('DayData')
class Days extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get mealPlanId =>
      integer().references(MealPlans, #id, onDelete: KeyAction.cascade)();
}

@DataClassName('MealData')
class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get dayId =>
      integer().references(Days, #id, onDelete: KeyAction.cascade)();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
}

@DriftDatabase(tables: [
  Recipes,
  Ingredients,
  Tags,
  RecipeTags,
  RecipeImages,
  Groceries,
  MealPlans,
  Days,
  Meals
], daos: [
  RecipesDao,
  IngredientsDao,
  TagsDao,
  GroceriesDao,
  MealPlansDao
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'recipes_db',
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }
}
