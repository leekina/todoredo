import 'package:chattodo/providers/duedo_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'canendar_page.state.g.dart';

@riverpod
class DuedoScrollController extends _$DuedoScrollController {
  @override
  ScrollController build() {
    ref.onAddListener(() {});
    return ScrollController();
  }

  void moveToCurrentDate(GlobalKey key) async {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0,
    );
  }
}

@riverpod
class DuedoListKeys extends _$DuedoListKeys {
  @override
  List<GlobalKey> build() {
    final duedoList = ref.watch(crudDuedoProvider);

    // duedoList가 로드되면 각 항목에 대한 GlobalKey 생성
    return duedoList.maybeWhen(
      data: (duedos) => duedos.map((_) => GlobalKey()).toList(),
      orElse: () => [],
    );
  }

  GlobalKey getKey(int index) {
    if (index >= 0 && index < state.length) {
      return state[index];
    }
    // 인덱스가 범위를 벗어난 경우 새로운 GlobalKey 반환
    return GlobalKey();
  }
}

@riverpod
class CurrentDate extends _$CurrentDate {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void updateCurrentDate(DateTime date) {
    state = date;
  }
}
