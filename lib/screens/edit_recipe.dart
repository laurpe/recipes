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
      body: SafeArea(
        child: SingleChildScrollView(
          child: EditRecipeForm(recipe: recipe),
        ),
      ),
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
  late bool _favorite;
  late int _servings;

  @override
  void initState() {
    _id = widget.recipe.id;
    _recipeName = widget.recipe.name;
    _instructions = widget.recipe.instructions;
    _ingredients = widget.recipe.ingredients;
    _favorite = widget.recipe.favorite;
    _servings = widget.recipe.servings;
    super.initState();
  }

  void _addIndgredient() {
    setState(() {
      _ingredients.add(const Ingredient(name: '', amount: '', unit: ''));
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
        favorite: _favorite,
        servings: _servings,
      );

      try {
        await GetIt.I<DatabaseClient>().updateRecipe(recipe);
        _formKey.currentState!.reset();

        if (!context.mounted) return;

        Navigator.of(context).pop(Updated(recipe));
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Name',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            ),
            onSaved: (value) {
              _recipeName = value!;
            },
            initialValue: _recipeName,
          ),
          TextFormField(
            validator: (value) {
              if (int.parse(value!) <= 0) {
                return 'Servings must be greater than 0';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Servings',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            ),
            onSaved: (value) {
              _servings = int.parse(value!);
            },
            initialValue: _servings.toString(),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field';
              }
              return null;
            },
            decoration: const InputDecoration(
                labelText: 'Instructions',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
            minLines: 8,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onSaved: (value) {
              _instructions = value!;
            },
            initialValue: _instructions,
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ingredients.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextFormField(
                        initialValue: _ingredients[index].amount,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
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
                              unit: _ingredients[index].unit,
                            );
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        initialValue: _ingredients[index].unit,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ingredient unit';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _ingredients[index] = Ingredient(
                              name: _ingredients[index].name,
                              amount: _ingredients[index].amount,
                              unit: value,
                            );
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: _ingredients[index].name,
                        decoration: InputDecoration(
                          labelText: 'Ingredient',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _ingredients.removeAt(index);
                              });
                            },
                          ),
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
                              unit: _ingredients[index].unit,
                            );
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addIndgredient,
                  child: const Text('Add ingredient'),
                ),
                ElevatedButton(
                    onPressed: _submitData, child: const Text('Save')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
