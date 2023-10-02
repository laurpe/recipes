import 'package:flutter/material.dart';
import 'package:recipes/recipe.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  final database = await openDatabase(
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

  Future<void> insertIngredient(Ingredient ingredient, int recipeId) async {
    final db = database;

    await db.insert(
      'ingredients',
      {...ingredient.toMap(), 'recipeId': recipeId},
    );
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = database;

    final recipeId = await db.insert(
      'recipes',
      recipe.toMap(),
    );

    for (var ingredient in recipe.ingredients) {
      await insertIngredient(ingredient, recipeId);
    }
  }

  final ingredient1 = Ingredient(amount: "2 kg", name: "kukkakaalia");
  final ingredient2 = Ingredient(amount: "2 dl", name: "kermaviiliä");
  final ingredient3 = Ingredient(amount: "1 rkl", name: "suolaa");

  final newRecipe = Recipe(
      name: "kukkakaaliwingsit",
      instructions: "Sekoita aineet",
      ingredients: [ingredient1, ingredient2, ingredient3]);

  await insertRecipe(newRecipe);

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
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: recipes.length,
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeView(recipe: recipes[index]),
                  ),
                );
              },
              child: Container(
                height: 50,
                color: Colors.amber[600],
                child: Center(
                    child: Text(recipes[index].name,
                        style: TextStyle(color: Colors.amber[50]))),
              ),
            );
          }),
    );
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

final letut = Recipe(
    name: "Letut",
    ingredients: [
      Ingredient(amount: "2 dl", name: "maitoa"),
      Ingredient(amount: "1 dl", name: "jauhoja")
    ],
    instructions: "sekoita");

final kakku = Recipe(
    name: "Kakku",
    ingredients: [
      Ingredient(name: "jauhoja", amount: "3 dl"),
      Ingredient(name: "sokeria", amount: "3 dl"),
      Ingredient(name: "kananmunia", amount: "3 kpl")
    ],
    instructions:
        "Lämmitä uuni 200 asteeseen. Vatkaa kananmunat ja sokeri kovaksi vaahdoksi. Sekoita varovasti joukkoon jauhot. Kaada voideltuun ja korppujauhotettuun vuokaan ja paista uunissa 200 asteessa noin 30 minuuttia, kunnes taikina on keskeltä kypsä.");

final recipes = [letut, kakku];
