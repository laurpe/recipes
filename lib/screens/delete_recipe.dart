import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/database.dart';

Future<void> confirmRecipeDelete(BuildContext context, int recipeId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm delete'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this recipe?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              try {
                await GetIt.I<DatabaseClient>().deleteRecipe(recipeId);

                if (!context.mounted) return;

                Navigator.of(context).popUntil((route) => route.isFirst);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Could not delete recipe! Please try again.')));
              }
            },
          )
        ],
      );
    },
  );
}
