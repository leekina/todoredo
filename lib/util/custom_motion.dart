import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomMotion extends StatefulWidget {
  final Function(BuildContext context)? onOpen;
  final Function(BuildContext context)? onClose;
  final Widget motionWidget;

  const CustomMotion({
    required this.motionWidget,
    this.onOpen,
    this.onClose,
    super.key,
  });

  @override
  CustomMotionState createState() => CustomMotionState();
}

class CustomMotionState extends State<CustomMotion> {
  SlidableController? controller;

  bool isClosed = true;

  void animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (controller?.ratio.abs() == controller?.endActionPaneExtentRatio &&
          isClosed) {
        isClosed = false;
        controller?.close();
        widget.onOpen!(context);
      }
      //close
      if ((controller?.ratio == 0) && widget.onClose != null && !isClosed) {
        isClosed = true;
        widget.onClose!(context);
      }
    }
  }

  @override
  void dispose() {
    controller?.animation.removeStatusListener(animationStatusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = Slidable.of(context);
    controller?.animation.addStatusListener(animationStatusListener);

    return widget.motionWidget;
  }
}
