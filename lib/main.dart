import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/models/chat.model.dart';
import 'package:todoredo/providers/providers.dart';
import 'package:todoredo/util/weekday_convertor.dart';

FocusNode textFocus = FocusNode();
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatProvider);
    final controller = useTextEditingController();
    final scrollController = useScrollController();

    ref.listen(
      chatProvider,
      (previous, next) {
        //if add todo scroll down until bottom
        if (next.value!.length > previous!.value!.length) {
          Future.delayed(
            const Duration(milliseconds: 10),
            () {
              scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut);
            },
          );
        }
      },
    );

    return GestureDetector(
      onTap: () => textFocus.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffeeeeee),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text('logo'),
          centerTitle: false,
          actions: const [],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: chat.maybeWhen(
                  data: (data) {
                    data.sort(
                      (a, b) {
                        return a.date.compareTo(b.date);
                      },
                    );
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final todo = data[index];
                        final date = DateFormat('MM. dd').format(todo.date);
                        final now = DateFormat('MM. dd').format(DateTime.now());
                        return Column(
                          children: [
                            if (index == 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: date == now
                                        ? Colors.lightGreenAccent
                                            .withOpacity(0.7)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                      '$date ${weekdayConvertor(todo.date.weekday)}'),
                                ),
                              )
                            else if (date !=
                                DateFormat('MM. dd')
                                    .format(data[index - 1].date))
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: date == now
                                        ? Colors.lightGreenAccent
                                            .withOpacity(0.7)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                      '$date ${weekdayConvertor(todo.date.weekday)}'),
                                ),
                              ),
                            Chat(todo: todo),
                          ],
                        );
                      },
                    );
                  },
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              BottomWidget(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomWidget extends HookConsumerWidget {
  const BottomWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectRe = useState(false);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextFormField(
        controller: controller,
        focusNode: textFocus,
        onFieldSubmitted: (value) {
          ref
              .read(chatProvider.notifier)
              .addchat(chat: value, re: selectRe.value);
          controller.clear();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              selectRe.value = !selectRe.value;
              controller.clear();
            },
            child: Icon(
              Icons.restart_alt,
              color: selectRe.value ? Colors.red : Colors.grey,
            ),
          ),
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ref
                  .read(chatProvider.notifier)
                  .addchat(chat: controller.text, re: selectRe.value);
              controller.clear();
            },
            child: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}

class Chat extends HookConsumerWidget {
  final Todo todo;
  const Chat({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = DateFormat('hh:mm').format(todo.date);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Dismissible(
        key: ValueKey(todo.id),
        onDismissed: (direction) {
          //반복이라면 내일 추가
          if (todo.redo) {
            ref.read(chatProvider.notifier).addchat(
                  chat: todo.title,
                  re: true,
                  date: DateTime.now().add(const Duration(days: 1)),
                );
          }
          ref.read(chatProvider.notifier).deleteChat(todo.id);
        },
        child: InkWell(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return EditChatDialog(todo);
              },
            );
          },
          onTap: () {
            //오늘이전꺼만 컴플리트 가능
            if (todo.date.isBefore(DateTime.now())) {
              ref.read(chatProvider.notifier).completeChat(todo.id);
            }

            //언포커스
            textFocus.unfocus();
          },
          child: Row(
            mainAxisAlignment:
                todo.redo ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!todo.redo)
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey),
                ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: todo.complete
                        ? Colors.green.withOpacity(0.8)
                        : Colors.white),
                child: Text(
                  todo.title,
                  style: TextStyle(
                    color: todo.date.isBefore(DateTime.now())
                        ? todo.complete
                            ? Colors.white
                            : Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (todo.redo)
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditChatDialog extends HookConsumerWidget {
  final Todo todo;
  const EditChatDialog(this.todo, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: todo.title);
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: TextField(
        controller: controller,
        autofocus: true,
      ),
      actions: [
        TextButton(
            onPressed: () {
              ref.read(chatProvider.notifier).deleteChat(todo.id);
              Navigator.pop(context);
            },
            child: const Text('삭제')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소')),
        TextButton(
            onPressed: () {
              ref
                  .read(chatProvider.notifier)
                  .editChat(todo.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('확인')),
      ],
    );
  }
}
