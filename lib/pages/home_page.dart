import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_example_firebase_well_structured/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _builUi(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      title: const Text(
        "Todo",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _builUi() {
    return SafeArea(
      child: Column(
        children: [
          _messageListView(),
        ],
      ),
    );
  }

  Widget _messageListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      //StreamBuilder est un widget qui va utiliser les data provenant d'un stream pour se build
      child: StreamBuilder(
        stream: _databaseService.getTodos(),
        builder: (context, snapshot) {
          List todos = snapshot.data?.docs ?? [];
          if (todos.isEmpty) {
            return const Center(
              child: Text("Add a todo"),
            );
          }
          return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index].data();
                //to access à l'id
                String todoId = todos[index].id;
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text(todo.task),
                    subtitle: Text(
                      DateFormat("dd/MM/yyyy hh:mm").format(
                        todo.updatedOn.toDate(),
                      ),
                    ),
                    trailing: Checkbox(
                      value: todo.isDone,
                      onChanged: (value) {
                        Todo updatedTodo = todo.copyWith(
                            //si todo.isDone = à true alors !todo.isDone set to false et vice versa
                            isDone: !todo.isDone,
                            updatedOn: Timestamp.now());
                        _databaseService.updateTodo(todoId, updatedTodo);
                      },
                    ),
                    onLongPress: () {
                      _databaseService.deleteTodo(todoId);
                    },
                  ),
                );
              });
        },
      ),
    );
  }
}
