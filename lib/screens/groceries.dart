import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recipes/blocs/groceries/bloc.dart';
import 'package:recipes/blocs/groceries/events.dart';
import 'package:recipes/blocs/groceries/state.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/grocery.dart';
import 'package:recipes/helpers/number_formatters.dart';
import 'package:recipes/repositories/grocery_repository.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final groceryRepository = GetIt.I<GroceryRepository>();
        return GroceriesBloc(groceryRepository: groceryRepository)
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
                      child: ReorderableGroceryList(
                          key: Key(
                              DateTime.now().microsecondsSinceEpoch.toString()),
                          groceries: state.groceries)),
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
  double _amount = 0;
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
        _amount = 0;
        _unit = '';
      });

      try {
        int id = await GetIt.I<AppDatabase>().addGrocery(grocery);

        Grocery newGrocery = grocery.copyWith(id: id);

        setState(() {
          _groceries.add(newGrocery);
          _groceries.sort((a, b) {
            if (a.isBought && !b.isBought) {
              return 1;
            } else if (!a.isBought && b.isBought) {
              return -1;
            }
            return 0;
          });
        });
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not add grocery, please try again!'),
            ),
          );
        }
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
                  initialValue: "",
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }

                    var formatted = value.replaceAll(',', '.');

                    if (double.tryParse(formatted) == null) {
                      return 'Please enter a valid number';
                    }

                    if (double.parse(formatted) <= 0) {
                      return 'Amount needs to be more than 0';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    var formatted = value!.replaceAll(',', '.');

                    _amount = double.parse(formatted);
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
              if (_groceries[oldIndex].isBought) return;
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
                      onTap: () async {
                        if (!grocery.isBought) {
                          /// if a grocery is marked bought, move it to the bottom of the list
                          /// no need to update the whole list order
                          Grocery updatedGrocery = grocery.copyWith(
                              isBought: true,
                              listOrder: DateTime.now().millisecondsSinceEpoch);

                          await GetIt.I<AppDatabase>()
                              .updateGrocery(updatedGrocery);
                          setState(() {
                            _groceries.remove(grocery);
                            _groceries.add(updatedGrocery);
                          });
                        } else if (grocery.isBought) {
                          /// if a grocery is marked not bought, move it to the top of the list
                          /// need to update the list order
                          Grocery updatedGrocery =
                              grocery.copyWith(isBought: false);

                          await GetIt.I<AppDatabase>()
                              .updateGrocery(updatedGrocery);
                          setState(() {
                            _groceries.remove(grocery);
                            _groceries.insert(0, updatedGrocery);
                            BlocProvider.of<GroceriesBloc>(context)
                                .add(ReorderGroceries(groceries: _groceries));
                          });
                        }
                      },
                      title: Text(
                          '${removeTrailingZero(grocery.amount)} ${grocery.unit} ${grocery.name}',
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
                                  GetIt.I<AppDatabase>()
                                      .deleteGrocery(grocery.id!);
                                  _groceries.remove(grocery);
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
