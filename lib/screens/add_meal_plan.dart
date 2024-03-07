import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
import 'package:recipes/meal_plan.dart';
import 'package:recipes/recipe.dart';

class MealPlanFormView extends StatelessWidget {
  const MealPlanFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create meal plan"),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: MealPlanForm(),
        ),
      ),
    );
  }
}

class MealPlanForm extends StatefulWidget {
  const MealPlanForm({super.key});

  @override
  State<MealPlanForm> createState() => MealPlanFormState();
}

class MealPlanFormState extends State<MealPlanForm> {
  final _formKey = GlobalKey<FormState>();
  late List<RecipeListItem> _recipes = [];

  MealPlan mealPlan = const MealPlan(name: 'Meal plan', days: [
    Day(name: 'Monday', meals: [
      Meal(name: 'Lunch', recipeId: null),
      Meal(name: 'Dinner', recipeId: null),
    ]),
    Day(name: 'Tuesday', meals: [
      Meal(name: 'Lunch', recipeId: null),
      Meal(name: 'Dinner', recipeId: null),
    ]),
    Day(name: 'Wednesday', meals: [
      Meal(name: 'Lunch', recipeId: null),
      Meal(name: 'Dinner', recipeId: null),
    ]),
    Day(name: 'Thursday', meals: [
      Meal(name: 'Lunch', recipeId: null),
      Meal(name: 'Dinner', recipeId: null),
    ]),
    Day(name: 'Friday', meals: [
      Meal(name: 'Lunch', recipeId: null),
      Meal(name: 'Dinner', recipeId: null),
    ]),
  ]);

  Future<List<RecipeListItem>> getRecipeList() async {
    return await GetIt.I<DatabaseClient>().getRecipeList();
  }

  @override
  void initState() {
    super.initState();

    getRecipeList().then((value) => setState(() => _recipes = value));
  }

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      GetIt.I<DatabaseClient>().insertMealPlan(mealPlan);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Meal plan name',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            ),
            onChanged: (value) {
              setState(() {
                mealPlan = mealPlan.copyWith(name: value);
              });
            },
          ),
          for (int i = 0; i < mealPlan.days!.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mealPlan.days![i].name,
                      style: Theme.of(context).textTheme.headlineMedium),
                  for (int j = 0; j < mealPlan.days![i].meals.length; j++)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(mealPlan.days![i].meals[j].name),
                          DropdownMenu(
                            width: 250,
                            requestFocusOnTap: true,
                            enableFilter: true,
                            onSelected: (value) {
                              Meal meal = mealPlan.days![i].meals[j]
                                  .copyWith(recipeId: value);

                              Day day = mealPlan.days![i].copyWith(
                                meals: [
                                  ...mealPlan.days![i].meals.sublist(0, j),
                                  meal,
                                  ...mealPlan.days![i].meals.sublist(j + 1),
                                ],
                              );

                              MealPlan newMealPlan = mealPlan.copyWith(
                                days: [
                                  ...mealPlan.days!.sublist(0, i),
                                  day,
                                  ...mealPlan.days!.sublist(i + 1),
                                ],
                              );

                              setState(() {
                                mealPlan = newMealPlan;
                              });
                            },
                            dropdownMenuEntries: _recipes
                                .map((recipe) => DropdownMenuEntry(
                                    value: recipe.id, label: recipe.name))
                                .toList(),
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
