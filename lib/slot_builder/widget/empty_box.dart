import 'package:flutter/material.dart';
import 'package:hudle_slots_view/hudle_slot_view.dart';
import 'package:hudle_theme/hudle_theme.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: MAX_BOX_SIZE * 0.10,
          bottom: MAX_BOX_SIZE * 0.05),
      width: MAX_BOX_SIZE,
      height: MAX_BOX_SIZE,
      decoration: BoxDecoration(
        color: kColorLegendNotAvailable,
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }
}
