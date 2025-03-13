import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/bloc_observer.dart';
import 'package:recipes/blocs/recipes/bloc.dart';
import 'package:recipes/blocs/recipes/events.dart';
import 'package:recipes/blocs/tags/bloc.dart';
import 'package:recipes/blocs/tags/events.dart';
import 'package:recipes/database_old.dart';
import 'package:recipes/screens/recipe_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton<DatabaseClient>(DatabaseClient());

  await GetIt.I<DatabaseClient>().initialize();
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
              final databaseClient = GetIt.I<DatabaseClient>();
              return RecipesBloc(databaseClient: databaseClient)
                ..add(const GetRecipes());
            },
          ),
          BlocProvider<TagsBloc>(
            create: (_) {
              final databaseClient = GetIt.I<DatabaseClient>();
              return TagsBloc(databaseClient: databaseClient)..add(GetTags());
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
