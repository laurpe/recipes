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
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          var batch = db.batch();
          batch.execute(
              'ALTER TABLE recipes ADD COLUMN favorite BOOLEAN DEFAULT 0');
          await batch.commit();
        }
        if (oldVersion < 3) {
          await db.execute('''CREATE TABLE new_ingredients(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            amount REAL,
            unit TEXT, 
            recipeId INTEGER, 
            FOREIGN KEY(recipeId) REFERENCES recipes(id) ON DELETE CASCADE)''');

          List<Map> oldData = await db.query('ingredients');
          for (var row in oldData) {
            String fullAmount = row['amount'];
            var split = fullAmount.split(' ');
            double amount = double.tryParse(split[0]) ?? 0;
            String unit = split.length > 1 ? split[1] : '';

            await db.insert('new_ingredients', {
              'id': row['id'],
              'name': row['name'],
              'amount': amount,
              'unit': unit,
              'recipeId': row['recipeId']
            });
          }
          await db.execute('DROP TABLE ingredients');
          await db.execute('ALTER TABLE new_ingredients RENAME TO ingredients');
        }
        if (oldVersion < 4) {
          await db.execute('''CREATE TABLE temp_ingredients(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            amount TEXT,
            unit TEXT, 
            recipeId INTEGER, 
            FOREIGN KEY(recipeId) REFERENCES recipes(id) ON DELETE CASCADE)''');

          List<Map> oldData = await db.query('ingredients');
          for (var row in oldData) {
            await db.insert('temp_ingredients', {
              'id': row['id'],
              'name': row['name'],
              'amount': row['amount'].toString(),
              'unit': row['unit'],
              'recipeId': row['recipeId']
            });
          }

          await db.execute('DROP TABLE ingredients');
          await db
              .execute('ALTER TABLE temp_ingredients RENAME TO ingredients');
        }
        if (oldVersion < 5) {
          await db.execute('''CREATE TABLE temp_ingredients(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            amount TEXT,
            unit TEXT, 
            recipeId INTEGER, 
            FOREIGN KEY(recipeId) REFERENCES recipes(id) ON DELETE CASCADE)''');

          List<Map> oldData = await db.query('ingredients');
          for (var row in oldData) {
            String amount = row['amount'];
            var split = amount.split('.');
            String finalAmount = split[0];

            await db.insert('temp_ingredients', {
              'id': row['id'],
              'name': row['name'],
              'amount': finalAmount,
              'unit': row['unit'],
              'recipeId': row['recipeId']
            });
          }

          await db.execute('DROP TABLE ingredients');
          await db
              .execute('ALTER TABLE temp_ingredients RENAME TO ingredients');
        }
        if (oldVersion < 6) {
          await db.execute('DROP TABLE IF EXISTS grocery_items');
          await db.execute('''CREATE TABLE groceries(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            amount TEXT,
            unit TEXT,
            is_bought BOOLEAN DEFAULT 0
            )''');
        }
      },
      version: 6,
    );
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
      ));
    }

    return recipeList;
  }
}
