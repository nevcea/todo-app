import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(controller: textController),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  todoCubit.addTodo(textController.text);
                  Navigator.of(context).pop();
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _showEditTodoBox(BuildContext context, Todo todo) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController(text: todo.text);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Todo"),
            content: TextField(controller: textController),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  final updatedTodo = todo.copyWith(text: textController.text);
                  todoCubit.updateTodo(updatedTodo);
                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTodoBox(context),
      ),

      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return ListTile(
                title: Text(todo.text),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    todoCubit.toggleCompletion(todo);
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 수정 아이콘
                    IconButton(
                      onPressed: () => _showEditTodoBox(context, todo),
                      icon: Icon(Icons.edit),
                    ),
                    // 삭제 아이콘
                    IconButton(
                      onPressed: () => todoCubit.deleteTodo(todo),
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
