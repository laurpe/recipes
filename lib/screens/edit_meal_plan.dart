import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/meal_plan.dart';
import 'package:recipes/models/recipe.dart';

import 'package:recipes/repositories/recipe_repository.dart';
import 'package:recipes/screens/meal_plan.dart';

class EditMealPlan extends StatelessWidget {
  final MealPlan mealPlan;

  const EditMealPlan({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit meal plan'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: EditMealPlanForm(mealPlan: mealPlan),
        ),
      ),
    );
  }
}

class EditMealPlanForm extends StatefulWidget {
  final MealPlan mealPlan;

  const EditMealPlanForm({super.key, required this.mealPlan});

  @override
  State<EditMealPlanForm> createState() => EditMealPlanFormState();
}

class EditMealPlanFormState extends State<EditMealPlanForm> {
  final _formKey = GlobalKey<FormState>();
  late List<Recipe> _recipes = [];
  late MealPlan _mealPlan;
  final RecipeRepository recipeRepository = GetIt.I<RecipeRepository>();

  @override
  void initState() {
    super.initState();

    recipeRepository
        .getRecipes()
        .then((value) => setState(() => _recipes = value));

    _mealPlan = widget.mealPlan;
  }

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await GetIt.I<AppDatabase>().mealPlansDao.updateMealPlan(_mealPlan);

        if (mounted) {
          Navigator.of(context).pop(Updated(_mealPlan));
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
    if (_recipes.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _mealPlan.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              ),
              onChanged: (value) {
                setState(() {
                  _mealPlan = _mealPlan.copyWith(name: value);
                });
              },
            ),
            TextFormField(
              validator: (value) {
                if (int.tryParse(value!) == null) {
                  return 'Servings per meal must be an integer';
                }
                if (int.parse(value) <= 0) {
                  return 'Servings per meal must be greater than 0';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Servings per meal',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              ),
              onSaved: (value) {
                setState(() {
                  _mealPlan =
                      _mealPlan.copyWith(servingsPerMeal: int.parse(value!));
                });
              },
              initialValue: _mealPlan.servingsPerMeal.toString(),
            ),
            for (int i = 0; i < _mealPlan.days!.length; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_mealPlan.days![i].name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    for (int j = 0; j < _mealPlan.days![i].meals.length; j++)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_mealPlan.days![i].meals[j].name),
                            FormField(
                              validator: (value) {
                                // TODO: show error when text is emptied
                                if (_mealPlan.days![i].meals[j].recipeId ==
                                    null) {
                                  return 'Please select a recipe';
                                }
                                return null;
                              },
                              builder: (FormFieldState state) => DropdownMenu(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                  isDense: true,
                                ),
                                width: 250,
                                requestFocusOnTap: true,
                                enableFilter: true,
                                errorText: state.errorText,
                                initialSelection:
                                    _mealPlan.days![i].meals[j].recipeId,
                                onSelected: (value) {
                                  Meal meal = _mealPlan.days![i].meals[j]
                                      .copyWith(recipeId: value);

                                  Day day = _mealPlan.days![i].copyWith(
                                    meals: [
                                      ..._mealPlan.days![i].meals.sublist(0, j),
                                      meal,
                                      ..._mealPlan.days![i].meals
                                          .sublist(j + 1),
                                    ],
                                  );

                                  MealPlan newMealPlan = _mealPlan.copyWith(
                                    days: [
                                      ..._mealPlan.days!.sublist(0, i),
                                      day,
                                      ..._mealPlan.days!.sublist(i + 1),
                                    ],
                                  );

                                  setState(() {
                                    _mealPlan = newMealPlan;
                                  });
                                },
                                dropdownMenuEntries: _recipes
                                    .map((recipe) => DropdownMenuEntry(
                                        value: recipe.id, label: recipe.name))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onSubmit();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}
