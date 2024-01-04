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
      child: GroceriesListView(),
    );
  }
}

class GroceriesListView extends StatelessWidget {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  GroceriesListView({super.key});

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
                _listKey.currentState!
                    .removeAllItems((context, animation) => Container());
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
              return AnimatedList(
                key: _listKey,
                initialItemCount: state.groceries.length,
                itemBuilder: (context, index, animation) {
                  return _buildItem(context, index, state.groceries.length,
                      state.groceries[index], animation);
                },
              );
          }
        },
      ),
    );
  }

  Widget _buildItem(context, int index, int length, Grocery item,
      Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _listKey.currentState!.removeItem(
            index,
            (context, animation) =>
                _buildItem(context, index, length, item, animation),
          );

          int insertIndex = item.isBought ? 0 : length - 1;

          _listKey.currentState!.insertItem(insertIndex);

          BlocProvider.of<GroceriesBloc>(context)
              .add(ToggleGroceryBought(grocery: item));
        },
        child: Card(
          child: ListTile(
            title: Text('${item.amount} ${item.unit} ${item.name}',
                style: item.isBought
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null),
          ),
        ),
      ),
    );
  }
}
