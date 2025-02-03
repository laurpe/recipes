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
        title: const Text("Add recipe"),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: RecipeForm(),
        ),
      ),
    );
  }
}

/*
* The ingredient amounts the user adds are for the amount of servings the recipe yields.
* From that input, ingredient amount_per_serving is calculated and stored to the database.
*/
class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() {
    return RecipeFormState();
  }
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final List<FocusNode> _ingredientFocusNodes = [];
  late FocusNode _buttonFocusNode;

  String _recipeName = '';
  String _instructions = '';
  final List<Ingredient> _ingredients = [];
  int _servings = 4;
  final List<Tag> _newTags = [];

  final TextEditingController _controller = TextEditingController();

  RegExp tagFieldRegex = RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ0-9-]+[ ,]?$');

  @override
  void initState() {
    super.initState();

    _controller.addListener(_handleTextChange);
    _buttonFocusNode = FocusNode();
  }

  void _handleTextChange() {
    String text = _controller.text;

    if (text.isNotEmpty &&
        tagFieldRegex.hasMatch(text) &&
        (text.endsWith(',') || text.endsWith(' '))) {
      String trimmedText = text.substring(0, text.length - 1).trim();
      setState(() {
        _newTags.add(Tag(name: trimmedText));
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    for (var ingredientFocusNode in _ingredientFocusNodes) {
      ingredientFocusNode.dispose();
    }
    _buttonFocusNode.dispose();

    super.dispose();
  }

  void _addIndgredient() {
    setState(() {
      _ingredients
          .add(const Ingredient(name: '', amountPerServing: 0, unit: ''));
      final ingredientFocusNode = FocusNode();
      _ingredientFocusNodes.add(ingredientFocusNode);
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
        List<Tag> existingTags = await GetIt.I<DatabaseClient>().getTags();

        List<int> tagIds = [];

        for (var newTag in _newTags) {
          if (existingTags.any((tag) => tag.name == newTag.name)) {
            Tag existingTag =
                existingTags.firstWhere((tag) => tag.name == newTag.name);
            tagIds.add(existingTag.id!);
          } else {
            int id = await GetIt.I<DatabaseClient>().insertTag(newTag);
            tagIds.add(id);
          }
        }

        int recipeId = await GetIt.I<DatabaseClient>().insertRecipe(recipe);
        await GetIt.I<DatabaseClient>().insertRecipeTags(recipeId, tagIds);

        _formKey.currentState!.reset();

        if (mounted) {
          Navigator.of(context).pop(Added(recipe));
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Something went wrong! Please try again.')));
        }
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
            autofocus: true,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'The name of your recipe',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            ),
            onSaved: (value) {
              _recipeName = value!;
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (int.tryParse(value!) == null) {
                return 'Servings must be an integer';
              }
              if (int.parse(value) <= 0) {
                return 'Servings must be greater than 0';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Servings',
              hintText: 'How many portions the recipe makes',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            ),
            onSaved: (value) => {_servings = int.parse(value!)},
            initialValue: _servings.toString(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: -4.0,
              alignment: WrapAlignment.center,
              children: [
                for (var tag in _newTags)
                  Chip(
                    label: Text(tag.name),
                    onDeleted: () {
                      setState(() {
                        _newTags.removeWhere((t) => t.name == tag.name);
                      });
                    },
                    deleteIcon: const Icon(
                      Icons.clear,
                      size: 18,
                    ),
                  )
              ],
            ),
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            autocorrect: false,
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Tags',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              hintText: 'Separate tags by comma or space',
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!tagFieldRegex.hasMatch(value)) {
                  return 'Only letters, numbers, and hyphens are allowed';
                }
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
              hintText: 'Describe how to prepare the dish',
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
                        focusNode: _ingredientFocusNodes[index],
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        initialValue: "",
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          hintText: '2',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ingredient amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            var amountAsDouble = double.tryParse(value);

                            double amountPerServing = 1.0;

                            if (amountAsDouble != null) {
                              amountPerServing = (amountAsDouble / _servings);
                            }
                            // Per dart documentation, .toStringAsFixed should not round numbers,
                            // but it seems to do that anyway.
                            _ingredients[index] = Ingredient(
                              name: _ingredients[index].name,
                              amountPerServing: double.parse(
                                  amountPerServing.toStringAsFixed(6)),
                              unit: _ingredients[index].unit,
                            );
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: _ingredients[index].unit,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          hintText: 'dl',
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
                              amountPerServing:
                                  _ingredients[index].amountPerServing,
                              unit: value,
                            );
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: _ingredients[index].name,
                        onFieldSubmitted: (_) {
                          _buttonFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          labelText: 'Ingredient name',
                          hintText: 'rice',
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
                              amountPerServing:
                                  _ingredients[index].amountPerServing,
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
                  focusNode: _buttonFocusNode,
                  onPressed: (() {
                    _addIndgredient();
                    _ingredientFocusNodes[_ingredientFocusNodes.length - 1]
                        .requestFocus();
                  }),
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
