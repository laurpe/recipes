import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/bloc_observer.dart';
import 'package:recipes/blocs/recipes/bloc.dart';
import 'package:recipes/blocs/recipes/events.dart';
import 'package:recipes/blocs/tags/bloc.dart';
import 'package:recipes/blocs/tags/events.dart';
import 'package:recipes/database.dart';
import 'package:recipes/repositories/grocery_repository.dart';
import 'package:recipes/repositories/ingredient_repository.dart';
import 'package:recipes/repositories/meal_plan_repository.dart';
import 'package:recipes/repositories/recipe_image_repository.dart';
import 'package:recipes/repositories/recipe_repository.dart';
import 'package:recipes/repositories/tag_repository.dart';
import 'package:recipes/screens/recipe_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = GetIt.I.registerSingleton<AppDatabase>(AppDatabase());

  GetIt.I.registerLazySingleton<RecipeRepository>(
      () => RecipeRepository(database: database));
  GetIt.I.registerLazySingleton<IngredientRepository>(
      () => IngredientRepository(database: database));
  GetIt.I.registerLazySingleton<TagRepository>(
      () => TagRepository(database: database));
  GetIt.I.registerLazySingleton<GroceryRepository>(
      () => GroceryRepository(database: database));
  GetIt.I.registerLazySingleton<MealPlanRepository>(
      () => MealPlanRepository(database: database));
  GetIt.I.registerLazySingleton<RecipeImageRepository>(
      () => RecipeImageRepository(database: database));

  Bloc.observer = MyBlocObserver();

  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RecipesBloc>(
            create: (_) {
              final recipeRepository = GetIt.I<RecipeRepository>();
              return RecipesBloc(recipeRepository: recipeRepository)
                ..add(const GetRecipes());
            },
          ),
          BlocProvider<TagsBloc>(
            create: (_) {
              final tagRepository = GetIt.I<TagRepository>();
              return TagsBloc(tagRepository: tagRepository)..add(GetTags());
            },
          ),
        ],
        child: MaterialApp(
            title: 'Recipes',
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                  scrolledUnderElevation: 0,
                  color: Colors.orange[800],
                  iconTheme: const IconThemeData(color: Colors.white),
                  actionsIconTheme: const IconThemeData(color: Colors.white),
                  titleTextStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.orange,
                primary: Colors.orange[800],
              ),
              inputDecorationTheme: const InputDecorationTheme(
                hintStyle: TextStyle(
                  color: Colors.black26,
                ),
                prefixIconColor: Colors.black26,
              ),
              textTheme: const TextTheme(
                titleLarge: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                headlineMedium: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                bodyMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              chipTheme: ChipThemeData(
                side: BorderSide.none,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                ),
                elevation: 1,
                shadowColor: Colors.black87,
                deleteIconColor: Colors.black54,
              ),
            ),
            home: RecipeList()));
  }
}
