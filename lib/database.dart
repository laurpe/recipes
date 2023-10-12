import 'dart:async';
import 'package:path/path.dart';
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
        await db.execute(
            'CREATE TABLE recipes(id INTEGER PRIMARY KEY, name TEXT, instructions TEXT)');
        await db.execute('''CREATE TABLE ingredients(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            amount TEXT, 
            recipeId INTEGER, 
            FOREIGN KEY(recipeId) REFERENCES recipes(id) ON DELETE CASCADE)''');
      },
      version: 1,
    );
  }

  Future<void> insertIngredient(Ingredient ingredient, int recipeId) async {
    await _database.insert(
      'ingredients',
      {...ingredient.toMap(), 'recipeId': recipeId},
    );
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final recipeId = await _database.insert(
      'recipes',
      recipe.toMap(),
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
          ingredients: await getIngredients(recipe['id'])));
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

    await _database.update('recipes', recipe.toMap(),
        where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<void> deleteRecipe(int recipeId) async {
    await _database.delete('recipes', where: 'id = ?', whereArgs: [recipeId]);
  }
}
