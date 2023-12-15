import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/groceries/bloc.dart';
import 'package:recipes/blocs/groceries/events.dart';
import 'package:recipes/blocs/groceries/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/grocery.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final databaseClient = GetIt.I<DatabaseClient>();
        return GroceriesBloc(databaseClient: databaseClient)
          ..add(GetGroceries());
      },
      child: const GroceriesListView(),
    );
  }
}

class GroceriesListView extends StatelessWidget {
  const GroceriesListView({super.key});

  Future<void> confirmGroceriesDelete(
      BuildContext context, GroceriesBloc bloc) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you sure you want to delete all groceries?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                bloc.add(DeleteGroceries());
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries'),
        actions: [
          IconButton(
            onPressed: () async {
              await confirmGroceriesDelete(
                  context, BlocProvider.of<GroceriesBloc>(context));
            },
            icon: const Icon(Icons.playlist_remove),
          ),
        ],
      ),
      body: BlocBuilder<GroceriesBloc, GroceriesState>(
        builder: (context, state) {
          switch (state) {
            case LoadingGroceriesState():
              return const Center(child: CircularProgressIndicator());
            case ErrorLoadingGroceriesState():
              return const Center(
                child: Text('Error loading groceries'),
              );
            case LoadedGroceriesState():
              return ListView.builder(
                itemCount: state.groceries.length,
                itemBuilder: (context, index) {
                  return GroceryListTile(grocery: state.groceries[index]);
                },
              );
          }
        },
      ),
    );
  }
}

class GroceryListTile extends StatelessWidget {
  final Grocery grocery;

  const GroceryListTile({
    super.key,
    required this.grocery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          BlocProvider.of<GroceriesBloc>(context)
              .add(ToggleGroceryBought(grocery: grocery));
        },
        title: Text(
          "${grocery.amount} ${grocery.unit} ${grocery.name}",
          style: TextStyle(
              decoration: grocery.isBought ? TextDecoration.lineThrough : null),
        ),
      ),
    );
  }
}
