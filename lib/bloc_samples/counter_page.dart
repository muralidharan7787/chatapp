import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text("BLoC Counter")),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Text(
              'Counter: ${state.counterValue}',
              style: TextStyle(fontSize: 28),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'decrement',
            child: Icon(Icons.remove),
            onPressed: () => bloc.add(DecrementCounter()),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'increment',
            child: Icon(Icons.add),
            onPressed: () => bloc.add(IncrementCounter()),
          ),
        ],
      ),
    );
  }
}
