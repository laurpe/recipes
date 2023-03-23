import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text("List of recipes will be here!")],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Recipe',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.yellow[700],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (int index) {
          // Add your onTap code here!
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(recipe.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Recipe {
  String name;
  List<String> ingredients;
  String instructions;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.instructions,
  });
}

final recipe = Recipe(
    name: "letut", ingredients: ["jauhoja", "maitoa"], instructions: "sekoita");
