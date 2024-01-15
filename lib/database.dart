import 'dart:async';
import 'package:path/path.dart';
import 'package:recipes/grocery.dart';
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
            is_bought BOOLEAN NOT NULL
            )''');
        await db.execute('''CREATE TABLE tags(
            id INTEGER PRIMARY KEY, 
            name TEXT NOT NULL 
            )''');
        await db.execute('''CREATE TABLE recipe_tags(
            recipe_id INTEGER NOT NULL,
            tag_id INTEGER NOT NULL,
            PRIMARY KEY(recipe_id, tag_id),
            FOREIGN KEY(recipe_id) REFERENCES recipes(id),
            FOREIGN KEY(tag_id) REFERENCES tags(id)
            )''');

        await _seedRecipes(db, seedRecipes);
        await _seedTags(db, seedTags);
        await _seedRecipeTags(db);
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
  }) async {
    late final List<Map<String, dynamic>> recipes;

    if (tags.isNotEmpty) {
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
