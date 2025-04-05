import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipes/blocs/tags/bloc.dart';
import 'package:recipes/blocs/tags/state.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/helpers/number_formatters.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe_detail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/models/tag.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class ImageData {
  final String name;
  final String path;

  const ImageData({required this.name, required this.path});
}

/// Stores the picked image to disk and returns its name and full path.
Future<ImageData> storeImageToDisk(XFile image) async {
  final Directory directory = await getApplicationDocumentsDirectory();

  final Directory imageDirectory = Directory('${directory.path}/images');

  if (!await imageDirectory.exists()) {
    await imageDirectory.create();
  }

  final String name = Uuid().v4();

  final String extension = path.extension(image.path);

  final String fullName = name + extension;

  File newImage = File('${imageDirectory.path}/$fullName');

  await image.saveTo(newImage.path);

  return ImageData(name: fullName, path: newImage.path);
}

Future<void> deleteImageFromDisk(String path) async {
  File image = File(path);

  try {
    await image.delete();
  } catch (error) {
    // TODO: handle properly
    print(error);
  }
}

/// The ingredient amounts the user adds are for the amount of servings the recipe yields.
/// From that input, ingredient amount_per_serving is calculated and stored to the database.

class RecipeForm extends StatefulWidget {
  final RecipeDetail initialValues;
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
  late double? _carbohydratesPerServing;
  late double? _proteinPerServing;
  late double? _fatPerServing;
  late double? _caloriesPerServing;

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
    _carbohydratesPerServing = widget.initialValues.carbohydratesPerServing;
    _proteinPerServing = widget.initialValues.proteinPerServing;
    _fatPerServing = widget.initialValues.fatPerServing;
    _caloriesPerServing = widget.initialValues.caloriesPerServing;

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

      // User has changed recipe image – delete old image
      if (widget.initialValues.imagePath != null && _imageChanged) {
        // TODO: this method exists in database client and here, move somewhere to share
        deleteImageFromDisk(widget.initialValues.imagePath!);

        GetIt.I<AppDatabase>()
            .recipesDao
            .deleteRecipeImage(widget.initialValues.id!);
      }

      ImageData? imageData =
          _image != null ? await storeImageToDisk(_image!) : null;

      final recipe = RecipeDetail(
        id: _id,
        name: _name,
        instructions: _instructions,
        ingredients: _ingredients,
        favorite: _favorite,
        servings: _servings,
        tags: _tags,
        imagePath: imageData
            ?.path, // may be null when user has not added or has deleted image
        carbohydratesPerServing: _carbohydratesPerServing,
        proteinPerServing: _proteinPerServing,
        fatPerServing: _fatPerServing,
        caloriesPerServing: _caloriesPerServing,
      );

      try {
        if (!mounted) return;
        final int recipeId = await widget.submitRecipe(context, recipe);

        if (imageData != null) {
          GetIt.I<AppDatabase>()
              .recipesDao
              .insertOrUpdateRecipeImage(recipeId, imageData.name);
        }

        _formKey.currentState!.reset();
      } catch (error) {
        print(error);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _image != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(_image!.path),
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        _image = null;
                        _imageChanged = true;
                      });
                    },
                    icon: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.delete,
                          size: 40,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black45,
                                blurRadius: 20.0,
                                offset: Offset(0, 2.0))
                          ]),
                    ),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: IconButton(
                    onPressed: () async {
                      var pickedImage = await _picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {
                        _image = pickedImage;
                        _imageChanged = true;
                      });
                    },
                    icon: Icon(
                      Icons.add_photo_alternate,
                      size: 50,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 20.0,
                          offset: Offset(0, 2.0),
                        )
                      ],
                    ),
                  ),
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
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _carbohydratesPerServing == null
                      ? ''
                      : removeTrailingZero(_carbohydratesPerServing!),
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != '') {
                      var formatted = value!.replaceAll(',', '.');

                      if (double.tryParse(formatted) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(formatted) <= 0) {
                        return 'Value needs to be more than 0';
                      }
                      if (double.parse(formatted) >= 1000) {
                        return 'Value needs to be under 1000';
                      }
                    }

                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Carbohydrates',
                    hintText: '60',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    suffixText: 'g',
                  ),
                  onChanged: (value) {
                    final String formatted = value.replaceAll(',', '.');

                    _carbohydratesPerServing = double.tryParse(formatted);
                  },
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: _proteinPerServing == null
                      ? ''
                      : removeTrailingZero(_proteinPerServing!),
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != '') {
                      var formatted = value!.replaceAll(',', '.');

                      if (double.tryParse(formatted) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(formatted) <= 0) {
                        return 'Value needs to be more than 0';
                      }
                      if (double.parse(formatted) >= 1000) {
                        return 'Value needs to be under 1000';
                      }
                    }

                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Protein',
                    hintText: '40',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    suffixText: 'g',
                  ),
                  onChanged: (value) {
                    final String formatted = value.replaceAll(',', '.');

                    _proteinPerServing = double.tryParse(formatted);
                  },
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: _fatPerServing == null
                      ? ''
                      : removeTrailingZero(_fatPerServing!),
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != '') {
                      var formatted = value!.replaceAll(',', '.');

                      if (double.tryParse(formatted) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(formatted) <= 0) {
                        return 'Value needs to be more than 0';
                      }
                      if (double.parse(formatted) >= 1000) {
                        return 'Value needs to be under 1000';
                      }
                    }

                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Fat',
                    hintText: '20',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    suffixText: 'g',
                  ),
                  onChanged: (value) {
                    final String formatted = value.replaceAll(',', '.');

                    _fatPerServing = double.tryParse(formatted);
                  },
                ),
              ),
            ],
          ),
          TextFormField(
            initialValue: _caloriesPerServing == null
                ? ''
                : removeTrailingZero(_caloriesPerServing!),
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value != '') {
                var formatted = value!.replaceAll(',', '.');

                if (double.tryParse(formatted) == null) {
                  return 'Please enter a valid number';
                }
                if (double.parse(formatted) <= 0) {
                  return 'Value needs to be more than 0';
                }
                if (double.parse(formatted) >= 1000) {
                  return 'Value needs to be under 1000';
                }
              }

              return null;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Calories',
              hintText: '650 ',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              suffixText: 'kcal',
            ),
            onChanged: (value) {
              final String formatted = value.replaceAll(',', '.');

              _caloriesPerServing = double.tryParse(formatted);
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
