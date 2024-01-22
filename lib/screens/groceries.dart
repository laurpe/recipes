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
  const GroceriesListView({
    super.key,
  });

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

// TODO: deleting all groceries doesn't work with reorderable list
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
              return Column(
                children: [
                  Expanded(
                      child:
                          ReorderableGroceryList(groceries: state.groceries)),
                ],
              );
          }
        },
      ),
    );
  }
}

class ReorderableGroceryList extends StatefulWidget {
  final List<Grocery> groceries;

  const ReorderableGroceryList({
    super.key,
    required this.groceries,
  });

  @override
  State<ReorderableGroceryList> createState() => ReorderableGroceryListState();
}

class ReorderableGroceryListState extends State<ReorderableGroceryList> {
  late List<Grocery> _groceries;

  final _groceriesFormKey = GlobalKey<FormState>();

  String _name = '';
  String _amount = '';
  String _unit = '';

  @override
  void initState() {
    super.initState();
    _groceries = widget.groceries;
  }

  Future<void> _submitGrocery() async {
    if (_groceriesFormKey.currentState!.validate()) {
      _groceriesFormKey.currentState!.save();

      final grocery = Grocery(
        name: _name,
        amount: _amount,
        unit: _unit,
        isBought: false,
        listOrder: DateTime.now().millisecondsSinceEpoch,
      );

      _groceriesFormKey.currentState!.reset();
      setState(() {
        _name = '';
        _amount = '';
        _unit = '';
      });

      try {
        int id = await GetIt.I<DatabaseClient>().insertGrocery(grocery);

        Grocery newGrocery = Grocery(
          id: id,
          name: grocery.name,
          amount: grocery.amount,
          unit: grocery.unit,
          isBought: grocery.isBought,
          listOrder: grocery.listOrder,
        );

        setState(() {
          _groceries.add(newGrocery);
        });
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not add grocery, please try again!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _groceriesFormKey,
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: TextFormField(
                  initialValue: _amount,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = value!;
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  initialValue: _unit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter unit';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _unit = value!;
                  },
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Grocery name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _submitGrocery,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter grocery name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final grocery = _groceries.removeAt(oldIndex);
                _groceries.insert(newIndex, grocery);
                BlocProvider.of<GroceriesBloc>(context)
                    .add(ReorderGroceries(groceries: _groceries));
              });
            },
            children: _groceries
                .map(
                  (grocery) => Card(
                    key: Key('${grocery.id}'),
                    child: ListTile(
                      onTap: () {
                        // TODO: implement this
                      },
                      title: Text(
                          '${grocery.amount} ${grocery.unit} ${grocery.name}',
                          style: grocery.isBought
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough)
                              : null),
                      trailing: MenuAnchor(
                        builder: (context, controller, child) {
                          return IconButton(
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            icon: const Icon(Icons.more_vert),
                            tooltip: 'Show menu',
                          );
                        },
                        menuChildren: [
                          MenuItemButton(
                              child: const Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                              onPressed: () async {
                                setState(() {
                                  _groceries.remove(grocery);
                                  GetIt.I<DatabaseClient>()
                                      .deleteGrocery(grocery.id!);
                                  BlocProvider.of<GroceriesBloc>(context)
                                      .add(GetGroceries());
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
