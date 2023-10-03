import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/recipe.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton<DatabaseClient>(DatabaseClient());

  await GetIt.I<DatabaseClient>().initialize();

  // const ingredient1 = Ingredient(amount: "2 kg", name: "kukkakaalia");
  // const ingredient2 = Ingredient(amount: "2 dl", name: "kermaviiliä");
  // const ingredient3 = Ingredient(amount: "1 rkl", name: "suolaa");

  // const newRecipe = Recipe(
  //     name: "kukkakaaliwingsit",
  //     instructions: "Sekoita aineet",
  //     ingredients: [ingredient1, ingredient2, ingredient3]);

  // await GetIt.I<DatabaseClient>().insertRecipe(newRecipe);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.yellow[700],
          secondary: Colors.yellow[700],
        ),
        fontFamily: 'Roboto',
      ),
      home: const RecipeList(),
    );
  }
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recipes'),
        ),
        body: FutureBuilder<List<Recipe>>(
            future: GetIt.I<DatabaseClient>().getRecipes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeView(recipe: snapshot.data![index]),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          color: Colors.amber[600],
                          child: Center(
                            child: Text(snapshot.data![index].name,
                                style: TextStyle(color: Colors.amber[50])),
                          ),
                        ),
                      );
                    });
              } else {
                return const Text("");
              }
            }));
  }
}

class RecipeView extends StatelessWidget {
  final Recipe recipe;

  const RecipeView({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Ainesosat", style: Theme.of(context).textTheme.headlineSmall),
          ListView(
            shrinkWrap: true,
            children: [
              for (var ingredient in recipe.ingredients)
                Row(children: [
                  SizedBox(width: 60, child: Text(ingredient.amount)),
                  Text(ingredient.name)
                ]),
            ],
          ),
          Text(
            "Ohje",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(recipe.instructions),
        ],
      ),
    );
  }
}

// final letut = Recipe(
//     name: "Letut",
//     ingredients: [
//       Ingredient(amount: "2 dl", name: "maitoa"),
//       Ingredient(amount: "1 dl", name: "jauhoja")
//     ],
//     instructions: "sekoita");

// final kakku = Recipe(
//     name: "Kakku",
//     ingredients: [
//       Ingredient(name: "jauhoja", amount: "3 dl"),
//       Ingredient(name: "sokeria", amount: "3 dl"),
//       Ingredient(name: "kananmunia", amount: "3 kpl")
//     ],
//     instructions:
//         "Lämmitä uuni 200 asteeseen. Vatkaa kananmunat ja sokeri kovaksi vaahdoksi. Sekoita varovasti joukkoon jauhot. Kaada voideltuun ja korppujauhotettuun vuokaan ja paista uunissa 200 asteessa noin 30 minuuttia, kunnes taikina on keskeltä kypsä.");

// final recipes = [letut, kakku];
