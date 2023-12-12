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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries'),
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

class GroceryListTile extends StatefulWidget {
  final Grocery grocery;

  const GroceryListTile({
    super.key,
    required this.grocery,
  });

  @override
  State<GroceryListTile> createState() => _GroceryListTileState();
}

class _GroceryListTileState extends State<GroceryListTile> {
  late bool _isBought;

  @override
  void initState() {
    _isBought = widget.grocery.isBought;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: _isBought,
        onChanged: (value) async {
          await GetIt.I<DatabaseClient>()
              .toggleGroceryIsBought(widget.grocery, !_isBought);
          setState(() {
            _isBought = !_isBought;
          });
        },
        title: Text(
            "${widget.grocery.amount} ${widget.grocery.unit} ${widget.grocery.name}"),
      ),
    );
  }
}
