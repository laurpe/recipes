import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/screens/recipe.dart';

class EditRecipe extends StatelessWidget {
  final Recipe recipe;

  const EditRecipe({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit recipe'),
        centerTitle: false,
      ),
      body: EditRecipeForm(recipe: recipe),
    );
  }
}

class EditRecipeForm extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeForm({super.key, required this.recipe});

  @override
  EditRecipeFormState createState() {
    return EditRecipeFormState();
  }
}

class EditRecipeFormState extends State<EditRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  late int? _id;
  late String _recipeName;
  late String _instructions;
  late List<Ingredient> _ingredients;

  @override
  void initState() {
    _id = widget.recipe.id;
    _recipeName = widget.recipe.name;
    _instructions = widget.recipe.instructions;
    _ingredients = widget.recipe.ingredients;
    super.initState();
  }

  void _addIndgredient() {
    setState(() {
      _ingredients.add(const Ingredient(name: '', amount: ''));
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final recipe = Recipe(
        id: _id,
        name: _recipeName,
        instructions: _instructions,
        ingredients: _ingredients,
      );

      try {
        await GetIt.I<DatabaseClient>().updateRecipe(recipe);
        _formKey.currentState!.reset();

        if (!context.mounted) return;

        Navigator.of(context).pop(RecipeResult.updated);
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
              initialValue: _recipeName,
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
              initialValue: _instructions,
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
          ElevatedButton(onPressed: _submitData, child: const Text('Save'))
        ]));
  }
}
