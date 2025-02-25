import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipes/blocs/tags/bloc.dart';
import 'package:recipes/blocs/tags/state.dart';
import 'package:recipes/helpers/ingredient_formatters.dart';
import 'package:recipes/recipe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import '../database.dart';

/// Stores the picked image to disk and returns its name and full path.
Future<Map<String, String>> storeImage(XFile image) async {
  final directory = await getApplicationDocumentsDirectory();

  final imageDirectory = Directory('${directory.path}/images');

  if (!await imageDirectory.exists()) {
    await imageDirectory.create();
  }

  String name = Uuid().v4();

  final extension = path.extension(image.path);

  final fullName = name + extension;

  File newImage = File('${imageDirectory.path}/$fullName');

  await image.saveTo(newImage.path);

  return {'name': fullName, 'path': newImage.path};
}

/// Adds image name and recipe id to images table.
Future<void> addImageToRecipe(String name, int recipeId) async {
  GetIt.I<DatabaseClient>().saveRecipeImage(recipeId, name);
}

/// The ingredient amounts the user adds are for the amount of servings the recipe yields.
/// From that input, ingredient amount_per_serving is calculated and stored to the database.

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
  final FocusNode _tagFocusNode = FocusNode();

  final TextEditingController _controller = TextEditingController();

  RegExp tagFieldRegex = RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ0-9-]+[ ,]?$');

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  bool _imageChanged = false;

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

    _image = widget.initialValues.imagePath == null
        ? null
        : XFile(widget.initialValues.imagePath!);

    _controller.addListener(_handleTextChange);

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
        // TODO: rewrite this

        Recipe? newRecipe;
        Map<String, String>? imageInfo;

        if (_image != null && _imageChanged) {
          var result = await storeImage(_image!);

          imageInfo = result;

          newRecipe = recipe.copyWith(imagePath: imageInfo['path']);
        }

        var recipeId = await widget.submitRecipe(context, newRecipe ?? recipe);

        if (newRecipe != null) {
          addImageToRecipe(imageInfo!['name']!, recipeId);
        }

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
          _image != null
              ? Image.file(File(_image!.path))
              : Text('No image selected'),
          ElevatedButton(
            onPressed: () async {
              var pickedImage = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              setState(() {
                _image = pickedImage;
                _imageChanged = true;
              });
            },
            child: Text(_image == null ? 'Add image' : 'Change image'),
          ),
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
              if (int.parse(value) > 100) {
                return 'Servings must be less than 100';
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
            onChanged: (value) {
              /// When serving size is changed, we want to keep
              /// the ingredient amounts the same. For this, we need
              /// to calculate the amountPerServing to match the
              /// new serving size, so that we store correct amountPerServing
              /// to the database.

              var originalServings = _servings;

              _servings = int.tryParse(value) ?? 1;

              for (var i = 0; i < _ingredients.length; i++) {
                var originalTotal =
                    _ingredients[i].amountPerServing * originalServings;
                var newAmount = originalTotal / _servings;

                _ingredients[i] = Ingredient(
                  name: _ingredients[i].name,
                  amountPerServing:
                      _ingredients[i].amountPerServing != 0 ? newAmount : 0,
                  unit: _ingredients[i].unit,
                );
              }
            },
          ),
          BlocBuilder<TagsBloc, TagsState>(
            builder: (BuildContext context, TagsState state) {
              switch (state) {
                case LoadingTagsState():
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case ErrorLoadingTagsState():
                  return const Center(
                    child: Text('Error loading tags'),
                  );
                case LoadedTagsState():
                  return Column(
                    children: [
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
                                    _tags
                                        .removeWhere((t) => t.name == tag.name);
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
                      RawAutocomplete<Tag>(
                        focusNode: _tagFocusNode,
                        textEditingController: _controller,
                        displayStringForOption: (Tag tag) => tag.name,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Tag>.empty();
                          }
                          return state.tags
                              .where((tag) => tag.name.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()))
                              .toList();
                        },
                        onSelected: (Tag tag) {
                          setState(() {
                            _tags.add(tag);
                          });
                          _controller.clear();
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: Container(
                                constraints: BoxConstraints(
                                    maxHeight: 200, minWidth: 200),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final tag = options.elementAt(index);
                                    return ListTile(
                                      title: Text(tag.name),
                                      onTap: () {
                                        onSelected(tag);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'Tags',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 20, 10, 20),
                              hintText: 'Separate tags by space',
                            ),
                            onFieldSubmitted: (value) {
                              onFieldSubmitted();
                            },
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!tagFieldRegex.hasMatch(value)) {
                                  return 'Only letters, numbers, and hyphens are allowed';
                                }
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          );
                        },
                      ),
                    ],
                  );
              }
            },
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
                            : formatIngredientAmount(
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
