import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';
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
  final List<String> days = [
    'Maanantai',
    'Tiistai',
    'Keskiviikko',
    'Torstai',
    'Perjantai'
  ];
  final List<String> meals = ['Lounas', 'Päivällinen'];
  Map<String, Map<String, TextEditingController>> dayMealControllers = {};

  @override
  void initState() {
    super.initState();
    for (var day in days) {
      Map<String, TextEditingController> mealControllers = {};
      for (var meal in meals) {
        mealControllers[meal] = TextEditingController();
      }
      dayMealControllers[day] = mealControllers;
    }
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      for (var day in days) {
        for (var meal in meals) {
          print(
              'Day: $day, Meal: $meal, Recipe: ${dayMealControllers[day]![meal]!.text}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (var day in days)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DaysMealSelect(
                day: day, meals: meals, controllers: dayMealControllers[day]!),
          ),
        ElevatedButton(
            child: const Text('Submit'),
            onPressed: () {
              onSubmit();
            }),
      ]),
    );
  }
}

class DaysMealSelect extends StatelessWidget {
  final String day;
  final List<String> meals;
  final Map<String, TextEditingController> controllers;

  const DaysMealSelect(
      {super.key,
      required this.day,
      required this.meals,
      required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(day, style: Theme.of(context).textTheme.headlineMedium),
        for (var meal in meals)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(meal),
                RecipeDropDown(controller: controllers[meal]!),
              ],
            ),
          ),
      ],
    );
  }
}

class RecipeDropDown extends StatefulWidget {
  final TextEditingController controller;
  const RecipeDropDown({super.key, required this.controller});

  @override
  State<RecipeDropDown> createState() => RecipeDropDownState();
}

class RecipeDropDownState extends State<RecipeDropDown> {
  final TextEditingController textController = TextEditingController();
  late List<RecipeListItem> _recipes = [];

  Future<List<RecipeListItem>> getRecipeList() async {
    return await GetIt.I<DatabaseClient>().getRecipeList();
  }

  @override
  void initState() {
    super.initState();
    getRecipeList().then((value) => setState(() => _recipes = value));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        width: 250,
        controller: widget.controller,
        requestFocusOnTap: true,
        enableFilter: true,
        dropdownMenuEntries: _recipes
            .map((recipe) => DropdownMenuEntry(
                value: recipe.id.toString(), label: recipe.name))
            .toList());
  }
}
