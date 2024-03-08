import 'dart:async';
import 'package:path/path.dart';
import 'package:recipes/grocery.dart';
import 'package:recipes/meal_plan.dart';
import 'package:recipes/seed_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recipes/recipe.dart';

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
            servings INTEGER NOT NULL
            )''');
        await db.execute('''CREATE TABLE ingredients(
            id INTEGER PRIMARY KEY, 
            name TEXT NOT NULL, 
            amount TEXT NOT NULL,
            unit TEXT NOT NULL, 
            recipeId INTEGER, 
            FOREIGN KEY(recipeId) REFERENCES recipes(id) ON DELETE CASCADE
            )''');
        await db.execute('''CREATE TABLE groceries(
            id INTEGER PRIMARY KEY, 
            name TEXT NOT NULL, 
            amount TEXT NOT NULL,
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
            name TEXT NOT NULL
            )''');
        await db.execute('INSERT INTO meal_plans VALUES (1, "Viikon ruoat")');

        await db.execute('''CREATE TABLE days(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            meal_plan_id INTEGER NOT NULL,
            FOREIGN KEY(meal_plan_id) REFERENCES meal_plans(id) ON DELETE CASCADE
            )''');
        await db.execute('INSERT INTO days VALUES (1, "Maanantai", 1)');
        await db.execute('INSERT INTO days VALUES (2, "Tiistai", 1)');
        await db.execute('INSERT INTO days VALUES (3, "Keskiviikko", 1)');
        await db.execute('INSERT INTO days VALUES (4, "Torstai", 1)');
        await db.execute('INSERT INTO days VALUES (5, "Perjantai", 1)');

        await db.execute('''CREATE TABLE meals(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            day_id INTEGER NOT NULL,
            recipe_id INTEGER NOT NULL,
            FOREIGN KEY(day_id) REFERENCES days(id) ON DELETE CASCADE,
            FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
            )''');
        await _seedRecipes(db, seedRecipes);
        await _seedTags(db, seedTags);
        await _seedRecipeTags(db);

        await db.execute('INSERT INTO meals VALUES (1, "Lounas", 1, 1)');
        await db.execute('INSERT INTO meals VALUES (2, "Päivällinen", 1, 2)');
        await db.execute('INSERT INTO meals VALUES (3, "Lounas", 2, 3)');
        await db.execute('INSERT INTO meals VALUES (4, "Päivällinen", 2, 4)');
        await db.execute('INSERT INTO meals VALUES (5, "Lounas", 3, 1)');
        await db.execute('INSERT INTO meals VALUES (6, "Päivällinen", 3, 2)');
        await db.execute('INSERT INTO meals VALUES (7, "Lounas", 4, 3)');
        await db.execute('INSERT INTO meals VALUES (8, "Päivällinen", 4, 4)');
        await db.execute('INSERT INTO meals VALUES (9, "Lounas", 5, 1)');
        await db.execute('INSERT INTO meals VALUES (10, "Päivällinen", 5, 2)');
      },
      // onUpgrade: (db, oldVersion, newVersion) async {
      // },
      version: 1,
    );
  }

  Future<void> _seedRecipes(Database db, List<Recipe> recipes) async {
    for (var recipe in recipes) {
      var recipeMap = recipe.toMap();
      recipeMap['favorite'] = recipe.favorite ? 1 : 0;

      final recipeId = await db.insert(
        'recipes',
        recipeMap,
      );

      for (var ingredient in recipe.ingredients) {
        await db.insert(
          'ingredients',
          {...ingredient.toMap(), 'recipeId': recipeId},
        );
      }
    }
  }

  Future<void> _seedTags(db, List<String> tags) async {
    for (var tag in tags) {
      await db.insert(
        'tags',
        {'name': tag},
      );
    }
  }

  Future<void> _seedRecipeTags(Database db) async {
    /// depends on recipe and tag seeds
    db.insert('recipe_tags', {'recipe_id': 1, 'tag_id': 4});
    db.insert('recipe_tags', {'recipe_id': 2, 'tag_id': 4});
    db.insert('recipe_tags', {'recipe_id': 3, 'tag_id': 2});
    db.insert('recipe_tags', {'recipe_id': 4, 'tag_id': 2});
    db.insert('recipe_tags', {'recipe_id': 4, 'tag_id': 3});
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

  Future<List<Tag>> getUsedTags() async {
    final List<Map<String, dynamic>> tags = await _database.rawQuery(
        'SELECT tags.* FROM tags INNER JOIN recipe_tags ON tags.id = recipe_tags.tag_id GROUP BY tags.id');

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

  Future<int> insertRecipe(Recipe recipe) async {
    var recipeMap = recipe.toMap();
    recipeMap['favorite'] = recipe.favorite ? 1 : 0;

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
        amount: ingredientMaps[i]['amount'],
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
      ));
    }

    return recipeList;
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
    recipeMap['favorite'] = recipe.favorite ? 1 : 0;

    await _database
        .update('recipes', recipeMap, where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<void> deleteRecipe(int recipeId) async {
    await _database.delete('recipes', where: 'id = ?', whereArgs: [recipeId]);
  }

  Future<Recipe> getRecipe(int recipeId) async {
    final List<Map<String, dynamic>> recipe = await _database.query('recipes',
        where: 'id = ?', whereArgs: [recipeId], limit: 1);

    return Recipe(
      id: recipe[0]['id'],
      name: recipe[0]['name'],
      instructions: recipe[0]['instructions'],
      ingredients: await getIngredients(recipe[0]['id']),
      favorite: recipe[0]['favorite'] == 1 ? true : false,
      servings: recipe[0]['servings'],
      tags: await getRecipeTags(recipe[0]['id']),
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
    updatedRecipeMap['favorite'] = favorite ? 1 : 0;

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
    groceryMap['is_bought'] = grocery.isBought ? 1 : 0;

    return await _database.insert(
      'groceries',
      groceryMap,
    );
  }

  Future<void> updateGrocery(Grocery grocery) async {
    var groceryMap = grocery.toMap();
    groceryMap['is_bought'] = grocery.isBought ? 1 : 0;

    await _database.update('groceries', groceryMap,
        where: 'id = ?', whereArgs: [grocery.id]);
  }

  Future<void> deleteGrocery(int groceryId) async {
    await _database
        .delete('groceries', where: 'id = ?', whereArgs: [groceryId]);
  }

  Future<void> deleteGroceries() async {
    await _database.delete('groceries');
  }

  Future<void> toggleGroceryBought(Grocery grocery, bool isBought) async {
    var groceryMap = grocery.toMap();
    groceryMap['is_bought'] = isBought ? 1 : 0;

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

  Future<List<Day>> getMealPlan(int mealPlanId) async {
    final List<Map<String, dynamic>> daysMap = await _database
        .query('days', where: 'meal_plan_id = ?', whereArgs: [mealPlanId]);

    final List<Map<String, dynamic>> daysMealsMap = await _database.query(
        'meals',
        where: 'day_id IN (${daysMap.map((d) => d['id']).join(',')})');

    final recipeNames = [];
    for (var meal in daysMealsMap) {
      recipeNames.add({
        'id': meal['recipe_id'],
        'name': await getRecipeName(meal['recipe_id'])
      });
    }

    String findRecipeName(int recipeId) {
      return recipeNames.firstWhere((r) => r['id'] == recipeId)['name'];
    }

    List<Day> days = daysMap.fold(<Day>[], (accumulator, day) {
      if (accumulator.any((d) => d.id == day['id'])) {
        return accumulator;
      }
      accumulator.add(Day(
        id: day['id'],
        name: day['name'],
        meals:
            daysMealsMap.where((meal) => meal['day_id'] == day['id']).map((m) {
          return Meal(
            id: m['id'],
            name: m['name'],
            recipeId: m['recipe_id'],
            recipeName: findRecipeName(m['recipe_id']),
          );
        }).toList(),
      ));
      return accumulator;
    });

    return days;
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
      {'name': mealPlan.name},
    );

    for (var day in mealPlan.days!) {
      var dayId = await insertDay(day, mealPlanId);
      for (var meal in day.meals) {
        await insertMeal(meal, dayId);
      }
    }
  }

  Future<void> deleteMealPlan(int mealPlanId) {
    return _database
        .delete('meal_plans', where: 'id = ?', whereArgs: [mealPlanId]);
  }
}
