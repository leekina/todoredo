import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_view.state.g.dart';

@riverpod
class MyScrollController extends _$MyScrollController {
  @override
  ScrollController build() {
    ref.onAddListener(
      () {},
    );
    return ScrollController();
  }

  void moveToBottom() async {
    state.jumpTo(40);
    await state.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
