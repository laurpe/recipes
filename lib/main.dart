import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/database.dart';

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
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecipeFormView(),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}

class RecipeFormView extends StatelessWidget {
  const RecipeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add new recipe"),
        ),
        body: RecipeForm());
  }
}

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() {
    return RecipeFormState();
  }
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter text';
            }
            return null;
          }),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing data')),
                  );
                }
              },
              child: const Text('Submit'))
        ]));
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
