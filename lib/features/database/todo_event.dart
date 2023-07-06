part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;

  AddTodo(this.todo);
}

class UpdateTodo extends TodoEvent {
  final Todo todo;

  UpdateTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final String todoId;

  DeleteTodo(this.todoId);
}
