import 'dart:async';
import 'package:path/path.dart';
import 'package:recipes/grocery.dart';
import 'package:recipes/seed_recipes.dart';
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
            is_bought BOOLEAN NOT NULL
            )''');
        _seedRecipes(seedRecipes);
      },
      // onUpgrade: (db, oldVersion, newVersion) async {
      // },
      version: 1,
    );
  }

  Future<void> _seedRecipes(List<Recipe> recipes) async {
    for (var recipe in recipes) {
      await insertRecipe(recipe);
    }
  }

  Future<void> insertIngredient(Ingredient ingredient, int recipeId) async {
    await _database.insert(
      'ingredients',
      {...ingredient.toMap(), 'recipeId': recipeId},
    );
  }

  Future<void> insertRecipe(Recipe recipe) async {
    var recipeMap = recipe.toMap();
    recipeMap['favorite'] = recipe.favorite ? 1 : 0;

    final recipeId = await _database.insert(
      'recipes',
      recipeMap,
    );

    for (var ingredient in recipe.ingredients) {
      await insertIngredient(ingredient, recipeId);
    }
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
    );
  }

  Future<List<Recipe>> paginateRecipes(int offset) async {
    final List<Map<String, dynamic>> recipes = await _database.query('recipes',
        orderBy: 'id', limit: 15, offset: offset);
    List<Recipe> recipeList = [];

    for (var recipe in recipes) {
      recipeList.add(Recipe(
        id: recipe['id'],
        name: recipe['name'],
        instructions: recipe['instructions'],
        ingredients: await getIngredients(recipe['id']),
        favorite: recipe['favorite'] == 1 ? true : false,
        servings: recipe['servings'],
      ));
    }

    return recipeList;
  }

  Future<void> toggleFavoriteRecipe(Recipe recipe, bool favorite) async {
    var updatedRecipe = Recipe(
      id: recipe.id,
      name: recipe.name,
      instructions: recipe.instructions,
      ingredients: recipe.ingredients,
      favorite: favorite,
      servings: recipe.servings,
    );

    var updatedRecipeMap = updatedRecipe.toMap();
    updatedRecipeMap['favorite'] = favorite ? 1 : 0;

    await _database.update('recipes', updatedRecipeMap,
        where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<List<Recipe>> searchRecipes({
    required int offset,
    required String query,
  }) async {
    final List<Map<String, dynamic>> recipes = await _database.query('recipes',
        where: 'name LIKE ?',
        whereArgs: ['%$query%'],
        offset: offset,
        limit: 15);
    List<Recipe> recipeList = [];

    for (var recipe in recipes) {
      recipeList.add(Recipe(
        id: recipe['id'],
        name: recipe['name'],
        instructions: recipe['instructions'],
        ingredients: await getIngredients(recipe['id']),
        favorite: recipe['favorite'] == 1 ? true : false,
        servings: recipe['servings'],
      ));
    }

    return recipeList;
  }

  Future<List<Grocery>> getGroceries() async {
    final List<Map<String, dynamic>> groceriesMap =
        await _database.query('groceries', orderBy: 'name');

    List<Grocery> groceries = List.generate(groceriesMap.length, (i) {
      return Grocery(
        id: groceriesMap[i]['id'],
        name: groceriesMap[i]['name'],
        amount: groceriesMap[i]['amount'],
        unit: groceriesMap[i]['unit'],
        isBought: groceriesMap[i]['is_bought'] == 1 ? true : false,
      );
    });

    return groceries
      ..sort((a, b) {
        if (a.isBought && !b.isBought) {
          return 1;
        } else if (!a.isBought && b.isBought) {
          return -1;
        }
        return 0;
      });
  }

  Future<void> insertGrocery(Grocery grocery) async {
    var groceryMap = grocery.toMap();
    groceryMap['is_bought'] = grocery.isBought ? 1 : 0;

    await _database.insert(
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

  Future<void> deleteGroceries() async {
    await _database.delete('groceries');
  }

  Future<void> toggleGroceryBought(Grocery grocery, bool isBought) async {
    var groceryMap = grocery.toMap();
    groceryMap['is_bought'] = isBought ? 1 : 0;

    await _database.update('groceries', groceryMap,
        where: 'id = ?', whereArgs: [grocery.id]);
  }
}
