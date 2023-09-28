import 'package:flutter/material.dart';
import 'package:recipes/recipe.dart';

void main() {
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

// class RecipeList extends StatelessWidget {
//   const RecipeList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recipes'),
//       ),
//       body: ListView.builder(
//           padding: const EdgeInsets.all(8),
//           itemCount: recipes.length,
//           itemBuilder: (BuildContext context, int index) {
//             return TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const RecipeView2(),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 color: Colors.amber[600],
//                 child: Center(child: Text(recipes[index].name)),
//               ),
//             );
//           }),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.note),
//             label: 'Recipe',
//           ),
//         ],
//         currentIndex: 0,
//         selectedItemColor: Colors.yellow[700],
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: true,
//         onTap: (int index) {
//           // Add your onTap code here!
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class RecipeView2 extends StatelessWidget {
//   const RecipeView2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recipe'),
//       ),
//       body: const RecipeList(),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.note),
//             label: 'Recipe',
//           ),
//         ],
//         currentIndex: 1,
//         selectedItemColor: Colors.yellow[700],
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: true,
//         onTap: (int index) {
//           // Add your onTap code here!
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.edit),
//       ),
//     );
//   }
// }

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
                child: Center(child: Text(recipes[index].name)),
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
