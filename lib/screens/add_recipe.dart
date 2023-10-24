import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required field';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              onSaved: (value) {
                _recipeName = value!;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required field';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Instructions',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              minLines: 10,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onSaved: (value) {
                _instructions = value!;
              },
            ),
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          initialValue: _ingredients[index].amount,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
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
                            labelText: 'Ingredient name',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  ),
                );
              },
            ),
          ),
          ElevatedButton(onPressed: _submitData, child: const Text('Submit'))
        ]));
  }
}
