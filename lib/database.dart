import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipes/models/grocery.dart';
import 'package:recipes/models/meal_plan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recipes/models/recipe.dart';

class DatabaseClient {
  late final Database _database;

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future initialize() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'recipe_database.db'),
      onConfigure: onConfigure,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE recipes(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            instructions TEXT NOT NULL,
            favorite BOOLEAN NOT NULL,
            servings INTEGER NOT NULL,
            carbohydrates_per_serving REAL,
            protein_per_serving REAL,
            fat_per_serving REAL,
            calories_per_serving REAL
            )''');
        await db.execute('''CREATE TABLE ingredients(
            id INTEGER PRIMARY KEY, 
            name TEXT NOT NULL, 
            amount_per_serving REAL NOT NULL,
            unit TEXT NOT NULL, 
            recipeId INTEGER, 
            FOREIGN KEY(recipeId) REFERENCES recipes(id) ON DELETE CASCADE
            )''');
        await db.execute('''CREATE TABLE groceries(
            id INTEGER PRIMARY KEY, 
            name TEXT NOT NULL, 
            amount REAL NOT NULL,
            unit TEXT NOT NULL,
            is_bought BOOLEAN NOT NULL,
            list_order INTEGER NOT NULL
            )''');
        await db.execute('''CREATE TABLE tags(
            id INTEGER PRIMARY KEY, 
            name TEXT NOT NULL 
            )''');
        await db.execute('''CREATE TABLE recipe_tags(
            recipe_id INTEGER NOT NULL,
            tag_id INTEGER NOT NULL,
            PRIMARY KEY(recipe_id, tag_id),
            FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
            FOREIGN KEY(tag_id) REFERENCES tags(id)
            )''');
        await db.execute('''CREATE TABLE meal_plans(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            servings_per_meal INTEGER NOT NULL
            )''');

        await db.execute('''CREATE TABLE days(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            meal_plan_id INTEGER NOT NULL,
            FOREIGN KEY(meal_plan_id) REFERENCES meal_plans(id) ON DELETE CASCADE
            )''');

        await db.execute('''CREATE TABLE meals(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            day_id INTEGER NOT NULL,
            recipe_id INTEGER NOT NULL,
            FOREIGN KEY(day_id) REFERENCES days(id) ON DELETE CASCADE,
            FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
            )''');

        await db.execute('''CREATE TABLE images(
              id INTEGER PRIMARY KEY,
              recipe_id INTEGER NOT NULL,
              name TEXT NOT NULL,
              FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
              )''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          var batch = db.batch();
          batch.execute('''CREATE TABLE IF NOT EXISTS images(
              id INTEGER PRIMARY KEY,
              recipe_id INTEGER NOT NULL,
              name TEXT NOT NULL,
              FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
              )''');
          await batch.commit();
        }

        if (oldVersion < 3) {
          var batch = db.batch();
          batch.execute(
              'ALTER TABLE recipes ADD COLUMN carbohydrates_per_serving REAL');
          batch.execute(
              'ALTER TABLE recipes ADD COLUMN protein_per_serving REAL');
          batch.execute('ALTER TABLE recipes ADD COLUMN fat_per_serving REAL');
          batch.execute(
              'ALTER TABLE recipes ADD COLUMN calories_per_serving REAL');
          await batch.commit();
        }
      },
      version: 3,
    );
  }

  Future<int> insertTag(Tag tag) async {
    return await _database.insert(
      'tags',
      tag.toMap(),
    );
  }

  Future<List<Tag>> getTags() async {
    final List<Map<String, dynamic>> tags = await _database.query('tags');
    List<Tag> tagList = [];

    for (var tag in tags) {
      tagList.add(Tag(
        id: tag['id'],
        name: tag['name'],
      ));
    }

    return tagList;
  }

  Future<void> insertIngredient(Ingredient ingredient, int recipeId) async {
    await _database.insert(
      'ingredients',
      {...ingredient.toMap(), 'recipeId': recipeId},
    );
  }

  Future<void> insertRecipeTags(int recipeId, List<int> tagIds) async {
    for (var tagId in tagIds) {
      await _database.insert(
        'recipe_tags',
        {'recipe_id': recipeId, 'tag_id': tagId},
      );
    }
  }

  Future<void> setRecipeTags(int recipeId, List<int> tagIds) async {
    await deleteRecipeTags(recipeId);

    for (var tagId in tagIds) {
      await _database.insert(
        'recipe_tags',
        {'recipe_id': recipeId, 'tag_id': tagId},
      );
    }
  }

  Future<int> insertRecipe(Recipe recipe) async {
    var recipeMap = recipe.toMap();

    final recipeId = await _database.insert(
      'recipes',
      recipeMap,
    );

    for (var ingredient in recipe.ingredients) {
      await insertIngredient(ingredient, recipeId);
    }

    return recipeId;
  }

  Future<List<Ingredient>> getIngredients(int recipeId) async {
    final List<Map<String, dynamic>> ingredientMaps = await _database
        .query('ingredients', where: 'recipeId = ?', whereArgs: [recipeId]);

    return List.generate(ingredientMaps.length, (i) {
      return Ingredient(
        id: ingredientMaps[i]['id'],
        name: ingredientMaps[i]['name'],
        amountPerServing: ingredientMaps[i]['amount_per_serving'],
        unit: ingredientMaps[i]['unit'],
      );
    });
  }

  Future<List<Tag>> getRecipeTags(int recipeId) async {
    final List<Map<String, dynamic>> tags = await _database.rawQuery(
        'SELECT * FROM tags INNER JOIN recipe_tags ON tags.id = recipe_tags.tag_id WHERE recipe_tags.recipe_id = ?',
        [recipeId]);
    List<Tag> tagList = [];

    for (var tag in tags) {
      tagList.add(Tag(
        id: tag['id'],
        name: tag['name'],
      ));
    }

    return tagList;
  }

  Future<void> deleteRecipeTags(int recipeId) async {
    await _database
        .delete('recipe_tags', where: 'recipe_id = ?', whereArgs: [recipeId]);
  }

  Future<void> updateRecipeTags(int recipeId, List<int> tagIds) async {
    await deleteRecipeTags(recipeId);
    await insertRecipeTags(recipeId, tagIds);
  }

  Future<List<Recipe>> getRecipes() async {
    final List<Map<String, dynamic>> recipes = await _database.query('recipes');
    List<Recipe> recipeList = [];

    for (var recipe in recipes) {
      recipeList.add(Recipe(
        id: recipe['id'],
        name: recipe['name'],
        instructions: recipe['instructions'],
        ingredients: await getIngredients(recipe['id']),
        favorite: recipe['favorite'] == 1 ? true : false,
        servings: recipe['servings'],
        tags: await getRecipeTags(recipe['id']),
        carbohydratesPerServing: recipe['carbohydrates_per_serving'],
        proteinPerServing: recipe['protein_per_serving'],
        fatPerServing: recipe['fat_per_serving'],
        caloriesPerServing: recipe['calories_per_serving'],
      ));
    }

    return recipeList;
  }

  Future<int> getRecipesCount() async {
    return Sqflite.firstIntValue(
          await _database.rawQuery('SELECT COUNT(*) FROM recipes'),
        ) ??
        0;
  }

  Future<void> deleteIngredient(int ingredientId) async {
    await _database
        .delete('ingredients', where: 'id = ?', whereArgs: [ingredientId]);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final oldIngredients = await getIngredients(recipe.id!);

    // delete recipe's old ingredients
    for (var ingredient in oldIngredients) {
      await deleteIngredient(ingredient.id!);
    }

    // add ingredients as new ingredients
    for (var ingredient in recipe.ingredients) {
      await insertIngredient(ingredient, recipe.id!);
    }

    var recipeMap = recipe.toMap();

    await _database
        .update('recipes', recipeMap, where: 'id = ?', whereArgs: [recipe.id]);
  }

  /// Deletes a recipe, possible recipe image and tags that are not used by
  /// any other recipe.
  Future<void> deleteRecipe(int recipeId) async {
    final directory = await getApplicationDocumentsDirectory();

    List<Map<String, dynamic>> image =
        await _database.query('images', where: 'id = ?', whereArgs: [recipeId]);

    if (image.isNotEmpty) {
      File file = File('${directory.path}/images/${image[0]['name']}');

      file.delete();
    }

    await _database.transaction((txn) async {
      await txn.delete('recipes', where: 'id = ?', whereArgs: [recipeId]);

      await txn.rawDelete('''
        DELETE FROM tags 
        WHERE id NOT IN (
            SELECT DISTINCT tag_id FROM recipe_tags
        )
      ''');
    });
  }

  Future<Recipe> getRecipe(int recipeId) async {
    final List<Map<String, dynamic>> recipe = await _database
        .query('recipes', where: 'id = ?', whereArgs: [recipeId]);

    // Currently a recipe can only have one image.
    final List<Map<String, dynamic>> imageName = await _database.query(
      'images',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );

    final directory = await getApplicationDocumentsDirectory();

    return Recipe(
      id: recipe[0]['id'],
      name: recipe[0]['name'],
      instructions: recipe[0]['instructions'],
      ingredients: await getIngredients(recipe[0]['id']),
      favorite: recipe[0]['favorite'] == 1 ? true : false,
      servings: recipe[0]['servings'],
      tags: await getRecipeTags(recipe[0]['id']),
      imagePath: imageName.isNotEmpty
          ? '${directory.path}/images/${imageName[0]['name']}'
          : null,
      carbohydratesPerServing: recipe[0]['carbohydrates_per_serving'],
      proteinPerServing: recipe[0]['protein_per_serving'],
      fatPerServing: recipe[0]['fat_per_serving'],
      caloriesPerServing: recipe[0]['calories_per_serving'],
    );
  }

  Future<void> toggleFavoriteRecipe(Recipe recipe, bool favorite) async {
    var updatedRecipe = Recipe(
      id: recipe.id,
      name: recipe.name,
      instructions: recipe.instructions,
      ingredients: recipe.ingredients,
      favorite: favorite,
      servings: recipe.servings,
      tags: recipe.tags,
    );

    var updatedRecipeMap = updatedRecipe.toMap();

    await _database.update('recipes', updatedRecipeMap,
        where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<List<Recipe>> searchRecipes({
    required int offset,
    required String query,
    required List<Tag> tags,
    required bool favorites,
  }) async {
    late final List<Map<String, dynamic>> recipes;

    if (favorites) {
      if (tags.isNotEmpty) {
        String tagIds = tags.map((t) => t.id).join(',');

        recipes = await _database.rawQuery(
            'SELECT recipes.* FROM recipes INNER JOIN recipe_tags ON recipes.id = recipe_tags.recipe_id WHERE (recipe_tags.tag_id IN ($tagIds) AND recipes.name LIKE ? AND recipes.favorite = 1) GROUP BY recipes.id HAVING COUNT(DISTINCT recipe_tags.tag_id) = ${tags.length} LIMIT 15 OFFSET ?',
            ['%$query%', offset]);
      } else {
        recipes = await _database.query('recipes',
            where: 'name LIKE ? AND favorite = 1',
            whereArgs: ['%$query%'],
            limit: 15,
            offset: offset);
      }
    } else if (tags.isNotEmpty) {
      String tagIds = tags.map((t) => t.id).join(',');

      recipes = await _database.rawQuery(
          'SELECT recipes.* FROM recipes INNER JOIN recipe_tags ON recipes.id = recipe_tags.recipe_id WHERE (recipe_tags.tag_id IN ($tagIds) AND recipes.name LIKE ?) GROUP BY recipes.id HAVING COUNT(DISTINCT recipe_tags.tag_id) = ${tags.length} LIMIT 15 OFFSET ?',
          ['%$query%', offset]);
    } else {
      recipes = await _database.query('recipes',
          where: 'name LIKE ?',
          whereArgs: ['%$query%'],
          limit: 15,
          offset: offset);
    }

    List<Recipe> recipeList = [];

    for (var recipe in recipes) {
      recipeList.add(Recipe(
        id: recipe['id'],
        name: recipe['name'],
        instructions: recipe['instructions'],
        ingredients: await getIngredients(recipe['id']),
        favorite: recipe['favorite'] == 1 ? true : false,
        servings: recipe['servings'],
        tags: await getRecipeTags(recipe['id']),
      ));
    }

    return recipeList;
  }

  Future<List<RecipeListItem>> getRecipeList() async {
    final List<Map<String, dynamic>> recipes = await _database.query('recipes');
    List<RecipeListItem> recipeList = [];

    for (var recipe in recipes) {
      recipeList.add(RecipeListItem(
        id: recipe['id'],
        name: recipe['name'],
      ));
    }

    return recipeList;
  }

  Future<List<Grocery>> getGroceries() async {
    final List<Map<String, dynamic>> groceriesMap =
        await _database.query('groceries', orderBy: 'list_order ASC');

    List<Grocery> groceries = List.generate(groceriesMap.length, (i) {
      return Grocery(
        id: groceriesMap[i]['id'],
        name: groceriesMap[i]['name'],
        amount: groceriesMap[i]['amount'],
        unit: groceriesMap[i]['unit'],
        isBought: groceriesMap[i]['is_bought'] == 1 ? true : false,
        listOrder: groceriesMap[i]['list_order'],
      );
    });

    return groceries;
  }

  Future<int> insertGrocery(Grocery grocery) async {
    var groceryMap = grocery.toMap();

    return await _database.insert(
      'groceries',
      groceryMap,
    );
  }

  Future<void> updateGrocery(Grocery grocery) async {
    var groceryMap = grocery.toMap();

    await _database.update('groceries', groceryMap,
        where: 'id = ?', whereArgs: [grocery.id]);
  }

  Future<void> deleteGrocery(int groceryId) async {
    await _database
        .delete('groceries', where: 'id = ?', whereArgs: [groceryId]);
  }

  Future<void> insertOrUpdateGroceries(List<Grocery> groceries) {
    return _database.transaction((txn) async {
      for (var grocery in groceries) {
        if (grocery.id == null) {
          await txn.insert('groceries', grocery.toMap());
        } else {
          await txn.update('groceries', grocery.toMap(),
              where: 'id = ?', whereArgs: [grocery.id]);
        }
      }
    });
  }

  Future<void> deleteGroceries() async {
    await _database.delete('groceries');
  }

  Future<void> toggleGroceryBought(Grocery grocery, bool isBought) async {
    var groceryMap = grocery.toMap();

    await _database.update('groceries', groceryMap,
        where: 'id = ?', whereArgs: [grocery.id]);
  }

  Future<List<MealPlan>> getMealPlansList() async {
    final List<Map<String, dynamic>> mealPlansMap =
        await _database.query('meal_plans');

    List<MealPlan> mealPlans = List.generate(mealPlansMap.length, (i) {
      return MealPlan(
        id: mealPlansMap[i]['id'],
        name: mealPlansMap[i]['name'],
        servingsPerMeal: mealPlansMap[i]['servings_per_meal'],
        days: null,
      );
    });
    return mealPlans;
  }

  Future<String> getRecipeName(int recipeId) async {
    final List<Map<String, dynamic>> recipe = await _database
        .query('recipes', where: 'id = ?', whereArgs: [recipeId]);

    return recipe[0]['name'];
  }

  Future<List<MealRecipe>> getMealRecipes(Set<int> recipeIds) async {
    List<Map<String, dynamic>> recipesMap = await _database.query(
      'recipes',
      columns: [
        'id',
        'name',
        'carbohydrates_per_serving',
        'protein_per_serving',
        'fat_per_serving',
        'calories_per_serving'
      ],
      where: 'id IN (${List.filled(recipeIds.length, '?').join(',')})',
      whereArgs: recipeIds.toList(),
    );

    return recipesMap
        .map((recipe) => MealRecipe(
            recipeId: recipe['id'],
            recipeName: recipe['name'],
            carbohydratesPerServing: recipe['carbohydrates_per_serving'],
            proteinPerServing: recipe['protein_per_serving'],
            fatPerServing: recipe['fat_per_serving'],
            caloriesPerServing: recipe['calories_per_serving']))
        .toList();
  }

  Future<MealPlan> getMealPlan(int mealPlanId) async {
    final List<Map<String, dynamic>> mealPlanMap = await _database
        .query('meal_plans', where: 'id = ?', whereArgs: [mealPlanId]);

    final List<Map<String, dynamic>> daysMap = await _database
        .query('days', where: 'meal_plan_id = ?', whereArgs: [mealPlanId]);

    final List<Map<String, dynamic>> mealsMap = await _database.query('meals',
        where: 'day_id IN (${daysMap.map((d) => d['id']).join(',')})');

    // Get unique recipe ids in meals.
    Set<int> recipeIds =
        mealsMap.map((meal) => meal['recipe_id'] as int).toSet();

    // Get recipe data for meals.
    List<MealRecipe> recipes = await getMealRecipes(recipeIds);

    List<Day> days = daysMap.fold(<Day>[], (accumulator, day) {
      if (accumulator.any((d) => d.id == day['id'])) {
        return accumulator;
      }
      accumulator.add(Day(
        id: day['id'],
        name: day['name'],
        meals: mealsMap.where((meal) => meal['day_id'] == day['id']).map((m) {
          MealRecipe recipeData =
              recipes.firstWhere((r) => r.recipeId == m['recipe_id']);

          return Meal(
            id: m['id'],
            name: m['name'],
            recipeId: m['recipe_id'],
            recipeName: recipeData.recipeName,
            carbohydratesPerServing: recipeData.carbohydratesPerServing,
            proteinPerServing: recipeData.proteinPerServing,
            fatPerServing: recipeData.fatPerServing,
            caloriesPerServing: recipeData.caloriesPerServing,
          );
        }).toList(),
      ));
      return accumulator;
    });

    MealPlan mealPlan = MealPlan(
        id: mealPlanId,
        name: mealPlanMap[0]['name'],
        servingsPerMeal: mealPlanMap[0]['servings_per_meal'],
        days: days);

    return mealPlan;
  }

  Future<List<Recipe>> getMealPlanRecipes(int mealPlanId) async {
    final List<Map<String, dynamic>> daysMap = await _database
        .query('days', where: 'meal_plan_id = ?', whereArgs: [mealPlanId]);

    final List<Map<String, dynamic>> mealsMap = await _database.query('meals',
        where: 'day_id IN (${daysMap.map((d) => d['id']).join(',')})');

    final List<Recipe> recipes = [];

    for (var meal in mealsMap) {
      recipes.add(await getRecipe(meal['recipe_id']));
    }

    return recipes;
  }

  Future<int> insertDay(Day day, int mealPlanId) async {
    return await _database.insert(
      'days',
      {...day.toMap(), 'meal_plan_id': mealPlanId},
    );
  }

  Future<int> insertMeal(Meal meal, int dayId) async {
    return await _database.insert(
      'meals',
      {...meal.toMap(), 'day_id': dayId},
    );
  }

  Future<void> insertMealPlan(MealPlan mealPlan) async {
    int mealPlanId = await _database.insert(
      'meal_plans',
      {'name': mealPlan.name, 'servings_per_meal': mealPlan.servingsPerMeal},
    );

    for (var day in mealPlan.days!) {
      var dayId = await insertDay(day, mealPlanId);
      for (var meal in day.meals) {
        await insertMeal(meal, dayId);
      }
    }
  }

  Future<int> updateMeal(Meal meal, int dayId) async {
    return await _database.update(
      'meals',
      {...meal.toMap(), 'day_id': dayId},
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  Future<int> updateDay(Day day, int mealPlanId) async {
    return await _database.update(
      'days',
      {...day.toMap(), 'meal_plan_id': mealPlanId},
      where: 'id = ?',
      whereArgs: [day.id],
    );
  }

  Future<void> updateMealPlan(MealPlan mealPlan) async {
    await _database.update('meal_plans',
        {'name': mealPlan.name, 'servings_per_meal': mealPlan.servingsPerMeal},
        where: 'id = ?', whereArgs: [mealPlan.id]);

    for (var day in mealPlan.days!) {
      await updateDay(day, mealPlan.id!);
      for (var meal in day.meals) {
        await updateMeal(meal, day.id!);
      }
    }
  }

  Future<void> deleteMealPlan(int mealPlanId) {
    return _database
        .delete('meal_plans', where: 'id = ?', whereArgs: [mealPlanId]);
  }

  /// Adds or updates recipe image and deletes old records if they exist.
  Future<void> insertOrUpdateRecipeImage(int recipeId, String name) async {
    List<Map<String, dynamic>> image =
        await _database.query('images', where: 'id = ?', whereArgs: [recipeId]);

    if (image.isNotEmpty && image[0]['name'] != name) {
      await _database.update(
        'images',
        {'name': name},
        where: 'id = ?',
        whereArgs: [image[0]['id']],
      );
    } else {
      await _database.insert('images', {'recipe_id': recipeId, 'name': name});
    }
  }

  Future<void> deleteRecipeImage(int recipeId) async {
    await _database
        .delete('images', where: 'recipe_id = ?', whereArgs: [recipeId]);
  }
}
