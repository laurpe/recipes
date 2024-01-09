import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/recipe.dart';
import 'package:recipes/screens/recipe.dart';

class RecipeFormView extends StatelessWidget {
  const RecipeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new recipe"),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: RecipeForm(),
        ),
      ),
    );
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
  bool _clearedProgrammatically = false;

  String _recipeName = '';
  String _instructions = '';
  final List<Ingredient> _ingredients = [];
  int _servings = 0;
  final List<String> _tagList = [];

  final TextEditingController _controller = TextEditingController();

  RegExp tagFieldRegex = RegExp(r'^[a-zA-Z0-9-]+[ ,]?$');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    String text = _controller.text;

    if (text.isNotEmpty &&
        tagFieldRegex.hasMatch(text) &&
        (text.endsWith(',') || text.endsWith(' '))) {
      String trimmedText = text.substring(0, text.length - 1).trim();
      setState(() {
        _tagList.add(trimmedText);
        _clearedProgrammatically = true;
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
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
        name: _recipeName,
        instructions: _instructions,
        ingredients: _ingredients,
        favorite: false,
        servings: _servings,
      );

      try {
        await GetIt.I<DatabaseClient>().insertRecipe(recipe);

        _formKey.currentState!.reset();

        if (!context.mounted) return;
        Navigator.of(context).pop(Added(recipe));
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
          Wrap(
            spacing: 8.0,
            alignment: WrapAlignment.center,
            children: [for (var tag in _tagList) Chip(label: Text(tag))],
          ),
          TextFormField(
            autocorrect: false,
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Tags',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              hintText: 'Separate tags by comma or space',
            ),
            validator: (value) {
              if (_clearedProgrammatically) {
                _clearedProgrammatically = false;
                return null;
              }

              if (value != null || value!.isNotEmpty) {
                if (!tagFieldRegex.hasMatch(value)) {
                  return 'Only letters, numbers, and hyphens are allowed';
                }
              }

              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            ),
            minLines: 8,
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
                          labelText: 'Ingredient name',
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
          ),
        ],
      ),
    );
  }
}
