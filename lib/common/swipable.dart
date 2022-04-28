// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Swipable extends StatelessWidget {
  final Widget child;
  final Function onLeftSwipe;
  final Function onRightSwipe;

  @override
  Widget build(BuildContext context) {
    var direction;
    const String LEFT = 'left';
    const String RIGHT = 'right';
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        HapticFeedback.vibrate();
        HapticFeedback.lightImpact();
        if (direction == RIGHT) {
          //HapticFeedback.lightImpact();
          onRightSwipe();
          print("Move to right ");
        }

        if (direction == LEFT) {
          //HapticFeedback.lightImpact();
          onLeftSwipe();
          print("Move to left ");
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) direction = RIGHT;
        if (details.delta.dx < 0) direction = LEFT;
      },
      child: child,
    );
  }

  Swipable(
      {required this.child,
      required this.onLeftSwipe,
      required this.onRightSwipe});
}
