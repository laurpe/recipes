import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe/bloc.dart';
import 'package:recipes/recipe/state.dart';

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
    return BlocProvider(
        create: (_) {
          final databaseClient = GetIt.I<DatabaseClient>();
          return RecipeBloc(databaseClient: databaseClient);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Recipes'),
          ),
          body: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (BuildContext context, RecipeState state) {
            if (state is LoadingRecipesState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ErrorLoadingRecipesState) {
              return const Center(child: Text('Error loading recipes'));
            }

            if (state is LoadedRecipesState) {
              ListView.builder(itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeView(recipe: state.recipes[index]),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    color: Colors.amber[600],
                    child: Center(
                      child: Text(state.recipes[index].name,
                          style: TextStyle(color: Colors.amber[50])),
                    ),
                  ),
                );
              });
            }
            return const Text("wut");
          }),
        ));
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Recipes'),
    //   ),
    //   body: BlocBuilder<RecipeBloc, RecipeState>(
    //       builder: (BuildContext context, RecipeState state) {
    //     if (state is LoadingRecipesState) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }

    //     if (state is ErrorLoadingRecipesState) {
    //       return const Center(child: Text('Error loading recipes'));
    //     }

    //     if (state is LoadedRecipesState) {
    //       ListView.builder(itemBuilder: (BuildContext context, int index) {
    //         return TextButton(
    //           onPressed: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) =>
    //                     RecipeView(recipe: state.recipes[index]),
    //               ),
    //             );
    //           },
    //           child: Container(
    //             height: 50,
    //             color: Colors.amber[600],
    //             child: Center(
    //               child: Text(state.recipes[index].name,
    //                   style: TextStyle(color: Colors.amber[50])),
    //             ),
    //           ),
    //         );
    //       });
    //     }
    //     return const Text("wut");
    //   }),
    // );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Recipes'),
    //   ),
    //   body: FutureBuilder<List<Recipe>>(
    //       future: GetIt.I<DatabaseClient>().getRecipes(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return ListView.builder(
    //               padding: const EdgeInsets.all(8),
    //               itemCount: snapshot.data!.length,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return TextButton(
    //                   onPressed: () {
    //                     Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                         builder: (context) =>
    //                             RecipeView(recipe: snapshot.data![index]),
    //                       ),
    //                     );
    //                   },
    //                   child: Container(
    //                     height: 50,
    //                     color: Colors.amber[600],
    //                     child: Center(
    //                       child: Text(snapshot.data![index].name,
    //                           style: TextStyle(color: Colors.amber[50])),
    //                     ),
    //                   ),
    //                 );
    //               });
    //         } else {
    //           return const Text("");
    //         }
    //       }),
    //   floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const RecipeFormView(),
    //           ),
    //         );
    //       },
    //       child: const Icon(Icons.add)),
    // );
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
        body:
            const SafeArea(child: SingleChildScrollView(child: RecipeForm())));
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
  String _recipeName = '';
  String _instructions = '';
  final List<Ingredient> _ingredients = [];

  void _addIndgredient() {
    setState(() {
      _ingredients.add(const Ingredient(name: '', amount: ''));
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final recipe = Recipe(
        name: _recipeName,
        instructions: _instructions,
        ingredients: _ingredients,
      );

      try {
        GetIt.I<DatabaseClient>().insertRecipe(recipe);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Recipe saved!')));
        _formKey.currentState!.reset();
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong! Please try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
            onSaved: (value) {
              _recipeName = value!;
            },
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field';
              }
              return null;
            },
            decoration: const InputDecoration(hintText: 'Instructions'),
            minLines: 10,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onSaved: (value) {
              _instructions = value!;
            },
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ingredients.length + 1,
              itemBuilder: (context, index) {
                if (index == _ingredients.length) {
                  return ElevatedButton(
                    onPressed: _addIndgredient,
                    child: const Text('Add ingredient'),
                  );
                }
                return Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: _ingredients[index].amount,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ingredient amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _ingredients[index] = Ingredient(
                              name: _ingredients[index].name,
                              amount: value,
                            );
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: _ingredients[index].name,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ingredient name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _ingredients[index] = Ingredient(
                              name: value,
                              amount: _ingredients[index].amount,
                            );
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _ingredients.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(onPressed: _submitData, child: const Text('Submit'))
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
