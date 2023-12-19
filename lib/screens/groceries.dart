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
          BlocProvider.of<GroceriesBloc>(context)
              .add(ToggleGroceryBought(grocery: item));
          _listKey.currentState!.removeItem(
            index,
            (context, animation) =>
                _buildItem(context, index, length, item, animation),
          );
          _listKey.currentState!.insertItem(length - 1);
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

class AnimatedGroceryList extends StatefulWidget {
  final List<Grocery> groceries;

  const AnimatedGroceryList({super.key, required this.groceries});

  @override
  AnimatedGroceryListState createState() => AnimatedGroceryListState();
}

class AnimatedGroceryListState extends State<AnimatedGroceryList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Grocery> _items;

  @override
  void initState() {
    _items = widget.groceries;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        return _buildItem(_items[index], animation);
      },
    );
  }

  Widget _buildItem(Grocery item, Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _moveItemToBottom(item);
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
      ),
    );
  }

  void _moveItemToBottom(Grocery item) {
    int currentIndex = _items.indexOf(item);
    _listKey.currentState!.removeItem(
      currentIndex,
      (context, animation) => _buildItem(item, animation),
    );
    _items.removeAt(currentIndex);
    _items.add(item);
    _listKey.currentState!.insertItem(_items.length - 1);
  }
}

// class GroceryListTile extends StatelessWidget {
//   final Grocery grocery;

//   const GroceryListTile({
//     super.key,
//     required this.grocery,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         onTap: () {
//           BlocProvider.of<GroceriesBloc>(context)
//               .add(ToggleGroceryBought(grocery: grocery));
//         },
//         title: Text(
//           "${grocery.amount} ${grocery.unit} ${grocery.name}",
//           style: TextStyle(
//               decoration: grocery.isBought ? TextDecoration.lineThrough : null),
//         ),
//       ),
//     );
//   }
// }
