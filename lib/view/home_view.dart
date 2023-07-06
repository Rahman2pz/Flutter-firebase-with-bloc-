import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:using_firebase/features/authentication/authentication_bloc.dart';
import 'package:using_firebase/features/database/todo_bloc.dart';
import 'package:using_firebase/model/todo_model.dart';
import 'package:using_firebase/utils/constants.dart';
import 'package:using_firebase/view/welcome_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoBloc _todoBloc = BlocProvider.of<TodoBloc>(context);
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const WelcomeView()),
                  (Route<dynamic> route) => false);
        }
      },
      buildWhen: ((previous, current) {
        if (current is AuthenticationFailure) {
          return false;
        }
        return true;
      }),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationSignedOut());
                  })
            ],
            systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.blue),
            title: Text((state as AuthenticationSuccess).displayName!),
          ),
          body: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TodoLoaded) {
                final todos = state.todos;
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(todo.title),
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (value) {
                          final updatedTodo = todo.copyWith(completed: value);
                          _todoBloc.add(UpdateTodo(updatedTodo));
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _todoBloc.add(DeleteTodo(todo.id));
                        },
                      ),
                    );
                  },
                );
              } else if (state is TodoOperationSuccess) {
                _todoBloc.add(LoadTodos()); // Reload todos
                return Container(); // Or display a success message
              } else if (state is TodoError) {
                return Center(child: Text(state.errorMessage));
              } else {
                return Container();
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddTodoDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
    void _showAddTodoDialog(BuildContext context) {
      final _titleController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const  Text('Add Todo'),
            content: TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Todo title'),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  final todo = Todo(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    completed: false,
                  );
                  BlocProvider.of<TodoBloc>(context).add(AddTodo(todo));
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

}