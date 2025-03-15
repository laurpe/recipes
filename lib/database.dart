import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipes/models/grocery.dart';
import 'package:recipes/models/meal_plan.dart';
import 'package:recipes/models/recipe.dart';

part 'database.g.dart';

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
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
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

  // RECIPES -----------------------------------

  // Get recipe.
  Future<Recipe> getRecipe(int recipeId) async {
    final recipeData = await (select(recipes)
          ..where((r) => r.id.equals(recipeId)))
        .getSingle();

    return Recipe(
      id: recipeData.id,
      name: recipeData.name,
      instructions: recipeData.instructions,
      ingredients: await getRecipeIngredients(recipeData.id),
      favorite: recipeData.favorite,
      servings: recipeData.servings,
      tags: await getRecipeTags(recipeData.id),
      imagePath: await getRecipeImagePath(recipeId),
      carbohydratesPerServing: recipeData.carbohydratesPerServing,
      proteinPerServing: recipeData.proteinPerServing,
      fatPerServing: recipeData.fatPerServing,
      caloriesPerServing: recipeData.caloriesPerServing,
    );
  }

  // Add a new recipe.
  // Ingredients, tags and image are added separately.
  Future<int> addRecipe(Recipe recipe) async {
    return await into(recipes).insert(recipe.toCompanion());
  }

  // Update a recipe.
  Future<void> updateRecipe(Recipe recipe) async {
    await (update(recipes)..where((r) => r.id.equals(recipe.id!)))
        .write(recipe.toCompanion());
  }

  // Delete a recipe, remove orphaned tasks and delete recipe image from disk.
  Future<void> deleteRecipe(int recipeId) async {
    // Fetch recipe image if it has one.
    final imageRow = await (select(recipeImages)
          ..where((i) => i.recipeId.equals(recipeId)))
        .getSingleOrNull();

    await transaction(() async {
      await (delete(recipes)..where((r) => r.id.equals(recipeId))).go();

      // Remove orphaned tags.
      await customStatement('''
        DELETE FROM tags 
        WHERE id NOT IN (
            SELECT DISTINCT tag_id FROM recipe_tags
        )
      ''');
    });

    // Delete image from disk.
    if (imageRow != null) {
      await deleteRecipeImageFromDisk(imageRow.name);
    }
  }

  // TODO: check where this is used, doesn't take the boolean anymore
  Future<void> toggleFavoriteRecipe(Recipe recipe) async {
    await (update(recipes)..where((r) => r.id.equals(recipe.id!)))
        .write(RecipesCompanion(favorite: Value(!recipe.favorite)));
  }

  // Search recipes.
  // TODO: refactor
  Future<List<Recipe>> searchRecipes({
    required int offset,
    required String query,
    required List<Tag> tags,
    required bool favorites,
  }) async {
    late final List<Map<String, dynamic>> recipeMaps;

    if (favorites) {
      if (tags.isNotEmpty) {
        final tagIds = tags.map((t) => t.id).join(',');
        final sql = '''
        SELECT recipes.* 
        FROM recipes 
        INNER JOIN recipe_tags ON recipes.id = recipe_tags.recipe_id 
        WHERE (recipe_tags.tag_id IN ($tagIds)
          AND recipes.name LIKE ?
          AND recipes.favorite = 1)
        GROUP BY recipes.id 
        HAVING COUNT(DISTINCT recipe_tags.tag_id) = ${tags.length} 
        LIMIT 15 OFFSET ?
      ''';
        final result = await customSelect(
          sql,
          variables: [
            Variable.withString('%$query%'),
            Variable.withInt(offset),
          ],
        ).get();
        recipeMaps = result.map((row) => row.data).toList();
      } else {
        final sql = '''
        SELECT * FROM recipes 
        WHERE name LIKE ? AND favorite = 1 
        LIMIT 15 OFFSET ?
      ''';
        final result = await customSelect(
          sql,
          variables: [
            Variable.withString('%$query%'),
            Variable.withInt(offset),
          ],
        ).get();
        recipeMaps = result.map((row) => row.data).toList();
      }
    } else if (tags.isNotEmpty) {
      final tagIds = tags.map((t) => t.id).join(',');
      final sql = '''
      SELECT recipes.* 
      FROM recipes 
      INNER JOIN recipe_tags ON recipes.id = recipe_tags.recipe_id 
      WHERE (recipe_tags.tag_id IN ($tagIds)
          AND recipes.name LIKE ?)
      GROUP BY recipes.id 
      HAVING COUNT(DISTINCT recipe_tags.tag_id) = ${tags.length} 
      LIMIT 15 OFFSET ?
    ''';
      final result = await customSelect(
        sql,
        variables: [
          Variable.withString('%$query%'),
          Variable.withInt(offset),
        ],
      ).get();
      recipeMaps = result.map((row) => row.data).toList();
    } else {
      final sql = '''
      SELECT * FROM recipes 
      WHERE name LIKE ? 
      LIMIT 15 OFFSET ?
    ''';
      final result = await customSelect(
        sql,
        variables: [
          Variable.withString('%$query%'),
          Variable.withInt(offset),
        ],
      ).get();
      recipeMaps = result.map((row) => row.data).toList();
    }

    List<Recipe> recipeList = [];
    for (final recipe in recipeMaps) {
      recipeList.add(
        Recipe(
          id: recipe['id'],
          name: recipe['name'],
          instructions: recipe['instructions'],
          ingredients: await getRecipeIngredients(recipe['id']),
          favorite: recipe['favorite'] == 1 ? true : false,
          servings: recipe['servings'],
          tags: await getRecipeTags(recipe['id']),
          imagePath: await getRecipeImagePath(recipe['id']),
          carbohydratesPerServing: recipe['carbohydratesPerServing'],
          proteinPerServing: recipe['proteinPerServing'],
          fatPerServing: recipe['fatPerServing'],
          caloriesPerServing: recipe['caloriesPerServing'],
        ),
      );
    }

    return recipeList;
  }

  // Get recipe list for front page.
  // TODO: is this necessary? fetching all recipe data anyway
  Future<List<RecipeListItem>> getRecipeList() async {
    final List<RecipeData> recipeDataList = await select(recipes).get();

    return recipeDataList
        .map((data) => RecipeListItem(
              id: data.id,
              name: data.name,
            ))
        .toList();
  }

  // Get recipe count.
  Future<int> getRecipesCount() async {
    final query = selectOnly(recipes)..addColumns([recipes.id.count()]);
    final row = await query.getSingle();
    return row.read(recipes.id.count()) ?? 0;
  }

  // RECIPE IMAGES -----------------------------

  // Add image to recipe or update it.
  Future<void> insertOrUpdateRecipeImage(int recipeId, String name) async {
    final imageData = await (select(recipeImages)
          ..where((ri) => ri.recipeId.equals(recipeId)))
        .getSingleOrNull();

    if (imageData != null) {
      await (update(recipeImages)..where((ri) => ri.id.equals(imageData.id)))
          .write(RecipeImagesCompanion(
        name: Value(name),
      ));
    } else {
      await into(recipeImages).insert(
        RecipeImagesCompanion.insert(
          recipeId: recipeId,
          name: name,
        ),
      );
    }
  }

  // Delete recipe image from recipeImages table.
  Future<void> deleteRecipeImage(int recipeId) async {
    await (delete(recipeImages)..where((ri) => ri.recipeId.equals(recipeId)))
        .go();
  }

  // Delete recipe image from disk.
  Future<void> deleteRecipeImageFromDisk(String name) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/images/$name');
    await file.delete();
  }

  // Helper to get recipe image path.
  Future<String?> getRecipeImagePath(int recipeId) async {
    final imageData = await (select(recipeImages)
          ..where((ri) => ri.recipeId.equals(recipeId)))
        .getSingleOrNull();

    final directory = await getApplicationDocumentsDirectory();

    return imageData != null
        ? '${directory.path}/images/${imageData.name}'
        : null;
  }

  // INGREDIENTS --------------------------------

  // Add a list of ingredients to a recipe.
  Future<void> addIngredients(
      int recipeId, List<Ingredient> ingredientList) async {
    await batch((batch) {
      batch.insertAll(
        ingredients,
        ingredientList
            .map((ingredient) => ingredient.toCompanion(recipeId))
            .toList(),
      );
    });
  }

  // Update a recipe's ingredients.
  // TODO: actually update instead of deleting and adding again
  Future<void> updateRecipeIngredients(
      int recipeId, List<Ingredient> ingredientList) async {
    await deleteRecipeIngredients(recipeId);
    await addIngredients(recipeId, ingredientList);
  }

  // Get a recipe's ingredients.
  Future<List<Ingredient>> getRecipeIngredients(int recipeId) async {
    List<IngredientData> ingredientList = await (select(ingredients)
          ..where((i) => i.recipeId.equals(recipeId)))
        .get();

    return ingredientList
        .map((i) => Ingredient(
            id: i.id,
            name: i.name,
            amountPerServing: i.amountPerServing,
            unit: i.unit))
        .toList();
  }

  // Delete a recipe's ingredients.
  Future<void> deleteRecipeIngredients(int recipeId) async {
    await (delete(ingredients)..where((i) => i.recipeId.equals(recipeId))).go();
  }

  // TAGS ---------------------------------------

  // Get all tags.
  Future<List<Tag>> getTags() async {
    List<TagData> tagList = await select(tags).get();
    return tagList.map((tag) => Tag(id: tag.id, name: tag.name)).toList();
  }

  // Add a list of tags and return their ids.
  // Can't use batch because it returns void.
  Future<List<int>> addTags(List<Tag> tagList) async {
    List<int> ids = [];

    for (var tag in tagList) {
      int id = await into(tags).insert(tag.toCompanion());

      ids.add(id);
    }

    return ids;
  }

  // Add or update tag.
  Future<int> insertOrUpdateTag(Tag tag) async {
    if (tag.id == null) {
      return await into(tags).insert(
        tag.toCompanion(),
      );
    } else {
      await (update(tags)..where((t) => t.id.equals(tag.id!)))
          .write(tag.toCompanion());
      return tag.id!;
    }
  }

// Get a recipe's tags.
  Future<List<Tag>> getRecipeTags(int recipeId) async {
    final query = select(recipeTags).join([
      innerJoin(tags, tags.id.equalsExp(recipeTags.tagId)),
    ])
      ..where(recipeTags.recipeId.equals(recipeId));

    final rows = await query.get();
    return rows.map((row) {
      final tagData = row.readTable(tags);
      return Tag(
        id: tagData.id,
        name: tagData.name,
      );
    }).toList();
  }

  // Add tags to a recipe.
  Future<void> addRecipeTags(int recipeId, List<int> tagIds) async {
    await batch((batch) {
      batch.insertAll(
        recipeTags,
        tagIds
            .map((tagId) =>
                RecipeTagsCompanion.insert(recipeId: recipeId, tagId: tagId))
            .toList(),
      );
    });
  }

  // Update a recipe's tags (delete old ones and add new ones).
  Future<void> updateRecipeTags(int recipeId, List<int> tagIds) async {
    await deleteRecipeTags(recipeId);
    await addRecipeTags(recipeId, tagIds);
  }

  // Delete recipe's tags.
  Future<void> deleteRecipeTags(int recipeId) async {
    await (delete(recipeTags)..where((t) => t.recipeId.equals(recipeId))).go();
  }

  // GROCERIES ---------------------------

  // Get groceries.
  Future<List<Grocery>> getGroceries() async {
    final groceriesList = await (select(groceries)
          ..orderBy([(g) => OrderingTerm(expression: g.listOrder)]))
        .get();

    return groceriesList
        .map((g) => Grocery(
              id: g.id,
              name: g.name,
              amount: g.amount,
              unit: g.unit,
              isBought: g.isBought,
              listOrder: g.listOrder,
            ))
        .toList();
  }

  // Add a grocery.
  Future<int> addGrocery(Grocery grocery) async {
    return await into(groceries).insert(grocery.toCompanion());
  }

  // Update a grocery.
  Future<void> updateGrocery(Grocery grocery) async {
    await (update(groceries)..where((g) => g.id.equals(grocery.id!)))
        .write(grocery.toCompanion());
  }

  // Delete a grocery.
  Future<void> deleteGrocery(int groceryId) async {
    await (delete(groceries)..where((g) => g.id.equals(groceryId))).go();
  }

  // Add or update groceries.
  // TODO: use this instead of the separate add or update methods when adding groceries from a recipe or a meal plan
  Future<void> insertOrUpdateGroceries(List<Grocery> groceryList) async {
    await transaction(() async {
      for (final grocery in groceryList) {
        if (grocery.id == null) {
          await into(groceries).insert(grocery.toCompanion());
        } else {
          await (update(groceries)..where((g) => g.id.equals(grocery.id!)))
              .write(grocery.toCompanion());
        }
      }
    });
  }

  // Delete all groceries.
  Future<void> deleteGroceries() async {
    await delete(groceries).go();
  }

  // TODO: check where this is used to remove the boolean argument
  Future<void> toggleGroceryBought(Grocery grocery) async {
    await (update(groceries)..where((g) => g.id.equals(grocery.id!)))
        .write(GroceriesCompanion(isBought: Value(!grocery.isBought)));
  }

  // MEAL PLANS ----------------------

  // Add a meal.
  Future<int> addMeal(Meal meal, int dayId) async {
    return await into(meals).insert(meal.toCompanion(dayId));
  }

  // TODO: does this need to return id?
  Future<int> updateMeal(Meal meal, int dayId) async {
    return await (update(meals)..where((m) => m.id.equals(meal.id!)))
        .write(meal.toCompanion(dayId));
  }

  // Add a day.
  Future<int> addDay(Day day, int mealPlanId) async {
    return await into(days).insert(day.toCompanion(mealPlanId));
  }

  // Update a day.
  Future<int> updateDay(Day day, int mealPlanId) async {
    return await (update(days)..where((d) => d.id.equals(day.id!)))
        .write(day.toCompanion(mealPlanId));
  }

  // Add a meal plan.
  Future<void> addMealPlan(MealPlan mealPlan) async {
    final mealPlanId = await into(mealPlans).insert(mealPlan.toCompanion());

    for (final day in mealPlan.days!) {
      final dayId = await addDay(day, mealPlanId);
      for (final meal in day.meals) {
        await addMeal(meal, dayId);
      }
    }
  }

  // Update a meal plan.
  Future<void> updateMealPlan(MealPlan mealPlan) async {
    await (update(mealPlans)..where((m) => m.id.equals(mealPlan.id!)))
        .write(mealPlan.toCompanion());

    for (final day in mealPlan.days!) {
      await updateDay(day, mealPlan.id!);
      for (final meal in day.meals) {
        await updateMeal(meal, day.id!);
      }
    }
  }

  // Delete a meal plan.
  Future<void> deleteMealPlan(int mealPlanId) async {
    await (delete(mealPlans)..where((m) => m.id.equals(mealPlanId))).go();
  }

  // Get list of meal plans.
  Future<List<MealPlan>> getMealPlansList() async {
    final mealPlanDataList = await select(mealPlans).get();

    return mealPlanDataList
        .map((data) => MealPlan(
              id: data.id,
              name: data.name,
              servingsPerMeal: data.servingsPerMeal,
              days: null,
            ))
        .toList();
  }

  // Get a recipe detail for a set of recipes.
  // TODO: rename MealRecipe
  Future<List<MealRecipe>> getRecipes(Set<int> recipeIds) async {
    final recipeList = await (select(recipes)
          ..where((r) => r.id.isIn(recipeIds.toList())))
        .get();
    return recipeList
        .map((r) => MealRecipe(
              recipeId: r.id,
              recipeName: r.name,
              carbohydratesPerServing: r.carbohydratesPerServing,
              proteinPerServing: r.proteinPerServing,
              fatPerServing: r.fatPerServing,
              caloriesPerServing: r.caloriesPerServing,
            ))
        .toList();
  }

  Future<MealPlan> getMealPlan(int mealPlanId) async {
    // Fetch the meal plan row.
    final mealPlanData = await (select(mealPlans)
          ..where((m) => m.id.equals(mealPlanId)))
        .getSingle();

    // Fetch the days belonging to this meal plan.
    final dayList = await (select(days)
          ..where((d) => d.mealPlanId.equals(mealPlanId)))
        .get();

    // Get the IDs of all days.
    final dayIds = dayList.map((d) => d.id).toList();

    // Fetch the meals for these days.
    final mealDataList =
        await (select(meals)..where((m) => m.dayId.isIn(dayIds))).get();

    // Collect the unique recipe IDs from the meals.
    final recipeIds = mealDataList.map((m) => m.recipeId).toSet();
    final mealRecipes = await getRecipes(recipeIds);

    // Build a list of Day objects.
    final List<Day> daysList = dayList.map((dayData) {
      // Filter meals that belong to the current day.
      final mealsForDay =
          mealDataList.where((m) => m.dayId == dayData.id).map((mealData) {
        final recipeData = mealRecipes.firstWhere(
          (r) => r.recipeId == mealData.recipeId,
          orElse: () => MealRecipe(
              recipeId: mealData.recipeId,
              recipeName: '',
              carbohydratesPerServing: 0,
              proteinPerServing: 0,
              fatPerServing: 0,
              caloriesPerServing: 0),
        );
        return Meal(
          id: mealData.id,
          name: mealData.name,
          recipeId: mealData.recipeId,
          recipeName: recipeData.recipeName,
          carbohydratesPerServing: recipeData.carbohydratesPerServing,
          proteinPerServing: recipeData.proteinPerServing,
          fatPerServing: recipeData.fatPerServing,
          caloriesPerServing: recipeData.caloriesPerServing,
        );
      }).toList();

      return Day(
        id: dayData.id,
        name: dayData.name,
        meals: mealsForDay,
      );
    }).toList();

    return MealPlan(
      id: mealPlanData.id,
      name: mealPlanData.name,
      servingsPerMeal: mealPlanData.servingsPerMeal,
      days: daysList,
    );
  }

  // Get a meal plan's recipes (all, not unique) to add all their total ingredients to groceries.
  // TODO: rethink
  Future<List<Recipe>> getMealPlanRecipes(int mealPlanId) async {
    final dayList = await (select(days)
          ..where((d) => d.mealPlanId.equals(mealPlanId)))
        .get();

    final dayIds = dayList.map((d) => d.id).toList();

    final mealDataList =
        await (select(meals)..where((m) => m.dayId.isIn(dayIds))).get();

    return Future.wait(
      mealDataList.map((meal) => getRecipe(meal.recipeId)),
    );
  }
}
