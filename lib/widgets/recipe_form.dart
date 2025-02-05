import 'package:flutter/material.dart';
import 'package:recipes/helpers/trim_trailing_zero.dart';
import 'package:recipes/recipe.dart';

/*
The ingredient amounts the user adds are for the amount of servings the recipe yields.
From that input, ingredient amount_per_serving is calculated and stored to the database.
*/

class RecipeForm extends StatefulWidget {
  final Recipe initialValues;
  final Function submitRecipe;

  const RecipeForm(
      {super.key, required this.initialValues, required this.submitRecipe});

  @override
  RecipeFormState createState() {
    return RecipeFormState();
  }
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  late int? _id;
  late String _name;
  late String _instructions;
  late List<Ingredient> _ingredients;
  late int _servings;
  late bool _favorite;
  late List<Tag> _tags;

  late List<FocusNode> _ingredientFocusNodes = [];

  final TextEditingController _controller = TextEditingController();

  RegExp tagFieldRegex = RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ0-9-]+[ ,]?$');

  @override
  void initState() {
    super.initState();

    _id = widget.initialValues.id;
    _name = widget.initialValues.name;
    _instructions = widget.initialValues.instructions;
    _ingredients = widget.initialValues.ingredients;
    _servings = widget.initialValues.servings;
    _favorite = widget.initialValues.favorite;
    _tags = widget.initialValues.tags!;

    _controller.addListener(_handleTextChange);
    ;

    _ingredientFocusNodes = [];

    if (_ingredients.isNotEmpty) {
      for (var _ in _ingredients) {
        _ingredientFocusNodes.add(FocusNode());
      }
    }
  }

  void _handleTextChange() {
    String text = _controller.text;

    if (text.isNotEmpty && tagFieldRegex.hasMatch(text) && text.endsWith(' ')) {
      String trimmedText = text.substring(0, text.length - 1).trim();
      setState(() {
        _tags.add(Tag(name: trimmedText));
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final recipe = Recipe(
        id: _id,
        name: _name,
        instructions: _instructions,
        ingredients: _ingredients,
        favorite: _favorite,
        servings: _servings,
        tags: _tags,
      );

      try {
        await widget.submitRecipe(context, recipe);

        //_formKey.currentState!.reset();
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
            initialValue: _name,
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
              _name = value!;
            },
          ),
          TextFormField(
            initialValue: _servings.toString(),
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: -4.0,
              alignment: WrapAlignment.center,
              children: [
                for (var tag in _tags)
                  Chip(
                    label: Text(tag.name),
                    onDeleted: () {
                      setState(() {
                        _tags.removeWhere((t) => t.name == tag.name);
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
              hintText: 'Separate tags by space',
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
            initialValue: _instructions,
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
                        initialValue: _ingredients[index].amountPerServing == 0
                            ? ''
                            : trimTrailingZero(
                                _ingredients[index].amountPerServing *
                                    _servings),
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

                          var formatted = value.replaceAll(',', '.');

                          if (double.tryParse(formatted) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(formatted) <= 0) {
                            return 'Amount needs to be more than 0';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            var formatted = value.replaceAll(',', '.');

                            var amountAsDouble = double.tryParse(formatted);

                            double amountPerServing = 1;

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
                        initialValue: _ingredients[index].unit,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        initialValue: _ingredients[index].name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done,
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
                  onPressed: (() {
                    _addIndgredient();
                    _ingredientFocusNodes.last.requestFocus();
                  }),
                  child: const Text('Add ingredient'),
                ),
                ElevatedButton(
                    onPressed: () => _handleSubmit(),
                    child: const Text('Submit')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
