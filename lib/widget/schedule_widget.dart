// ** V1에서는 안함 **


// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:chattodo/models/todo.model.dart';
// import 'package:chattodo/providers/todo_provider.dart';

// import 'package:chattodo/util/common.dart';
// import 'package:chattodo/widget/edit_chat_dialog.dart';
// import 'package:chattodo/widget/todo_view.dart';

// class ScheduleWidget extends HookConsumerWidget {
//   const ScheduleWidget({
//     super.key,
//     required this.schedule,
//   });

//   final Todo schedule;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = useAnimationController(
//       duration: const Duration(seconds: 1),
//     );
//     final curve =
//         CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
//     final animation =
//         useAnimation(Tween<double>(begin: -200, end: 0).animate(curve));
//     useEffect(() {
//       controller.forward();
//       return;
//     }, []);
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Dismissible(
//         key: ValueKey(schedule.id),
//         onDismissed: (direction) {
//           //디스미스
//           if (direction == DismissDirection.startToEnd) {
//             ref
//                 .read(crudTodoProvider.notifier)
//                 .addTodo(chat: schedule.title, date: schedule.createDate);
//           }
//           ref.read(crudScheduleProvider.notifier).deleteSchedule(schedule.id);
//         },
//         child: GestureDetector(
//           //길게 누르면 수정
//           onLongPress: () {
//             if (!schedule.complete) {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return EditTodoDialog(schedule);
//                 },
//               );
//             }
//           },

//           onDoubleTap: () {
//             //완료
//             ref.read(crudTodoProvider.notifier).addTodoFromSchedule(schedule);
//             ref.read(crudScheduleProvider.notifier).deleteSchedule(schedule.id);

//             //언포커스
//             addTodoNode.unfocus();
//           },
//           child: AnimatedBuilder(
//             animation: controller,
//             builder: (context, child) {
//               return Transform(
//                 transform: Matrix4.translationValues(animation, 0, 0),
//                 child: child,
//               );
//             },
//             child: TodoView(
//               todo: schedule,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
