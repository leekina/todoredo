import 'package:chattodo/models/todo.model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_widget.state.g.dart';

@riverpod
class CommentTodo extends _$CommentTodo {
  @override
  Todo? build() {
    return null;
  }

  void setTodo(Todo todo) {
    state = todo;
    if (todo.comment != null) {
      ref.read(todoTextfieldControllerProvider).text = todo.comment!;
    }
  }

  void initTodo() {
    state = null;
  }
}

@riverpod
class TodoTextfieldController extends _$TodoTextfieldController {
  @override
  TextEditingController build() {
    return TextEditingController();
  }
}

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DatePickerState build() {
    return DatePickerState(selectedDate: null, datePickerOn: false);
  }

  void setDate(DateTime date) {
    state = DatePickerState(selectedDate: date, datePickerOn: false);
  }

  void setDatePickerOn(bool datePickerOn) {
    state = DatePickerState(
        selectedDate: state.selectedDate, datePickerOn: datePickerOn);
  }

  void initDate() {
    state = DatePickerState(selectedDate: DateTime.now(), datePickerOn: true);
  }

  void deleteDate() {
    state = DatePickerState.init();
  }
}

class DatePickerState {
  final DateTime? selectedDate;
  final bool datePickerOn;

  DatePickerState({required this.selectedDate, required this.datePickerOn});
  factory DatePickerState.init() {
    return DatePickerState(selectedDate: null, datePickerOn: false);
  }
}
