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
        title: const Text('First Route'),
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
                    builder: (context) => const RecipeView(),
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
  const RecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

final letut = Recipe(
    name: "letut", ingredients: ["jauhoja", "maitoa"], instructions: "sekoita");
final kakku = Recipe(
    name: "kakku",
    ingredients: ["jauhoja", "maitoa", "kananmunia"],
    instructions: "sekoita ja paista");

final recipes = [letut, kakku];
