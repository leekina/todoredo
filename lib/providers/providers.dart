import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/chat.model.dart';

part 'providers.g.dart';

@riverpod
class Chat extends _$Chat {
  @override
  FutureOr<List<Todo>> build() {
    return [];
  }

  void addchat({required String chat, required bool re, DateTime? date}) {
    if (date == null) {
      state = AsyncData([...state.value!, Todo.add(todo: chat, re: re)]);
    } else {
      state = AsyncData(
          [...state.value!, Todo.add(todo: chat, re: re, date: date)]);
    }
  }

  void editChat(String id, String chat) {
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(title: chat) : todo
    ]);
  }

  void deleteChat(String id) {
    state = AsyncData([
      for (final todo in state.value!)
        if (todo.id != id) todo
    ]);
  }

  void completeChat(String id) {
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(complete: !todo.complete) : todo
    ]);
  }

  void changeReChat(String id) {
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(redo: !todo.redo) : todo
    ]);
  }
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
