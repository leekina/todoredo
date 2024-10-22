import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/repository/todo_repository.dart';

part 'providers.g.dart';

@riverpod
class Chat extends _$Chat {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todosRepositoryProvider).getTodos();
  }

  void addchat({required String chat, required bool re, DateTime? date}) {
    final newTodo = Todo.add(todo: chat, re: re, date: date ?? DateTime.now());

    ref.read(todosRepositoryProvider).addTodo(todo: newTodo);
    if (date == null) {
      state = AsyncData([...state.value!, newTodo]);
    } else {
      state = AsyncData([...state.value!, newTodo]);
    }
  }

  void editChat(String id, String chat) {
    ref.read(todosRepositoryProvider).editTodo(id: id, desc: chat);
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(title: chat) : todo
    ]);
  }

  void deleteChat(String id) {
    ref.read(todosRepositoryProvider).removeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value!)
        if (todo.id != id) todo
    ]);
  }

  void completeChat(String id) {
    ref.read(todosRepositoryProvider).completeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(complete: !todo.complete) : todo
    ]);
  }

  // void changeReChat(String id) {
  //   ref.read(todosRepositoryProvider).changeReTodo(id: id);
  //   state = AsyncData([
  //     for (final todo in state.value!)
  //       todo.id == id ? todo.copyWith(redo: !todo.redo) : todo
  //   ]);
  // }
}

@riverpod
class ChatUnComplete extends _$ChatUnComplete {
  @override
  FutureOr<List<Todo>> build() {
    final chat = ref.watch(chatProvider);

    return [
      for (final todo in chat.value!)
        if (todo.complete == false) todo
    ];
  }
}
