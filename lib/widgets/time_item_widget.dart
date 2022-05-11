// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:hudle_core/hudle_core.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_theme/hudle_theme.dart';

class TimeItem extends StatelessWidget {
  final String startTime;
  final String endTime;
  final bool showEndTime;

  const TimeItem(
      {Key? key,
      this.startTime = "12:00 AM",
      this.endTime = "01:00 AM",
      this.showEndTime = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 2,
      ),
      height: SlotInfo.slotHeight + 5,
      width: SlotInfo.timeWidth,
      //color: kColorError,
      margin: const EdgeInsets.only(
          right: 8,
          bottom: SlotInfo.slotWidth * 0.05,
          top: SlotInfo.slotWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NormalText(
            startTime,
            color: kTertiaryText,
            fontSize: 10,
          ),
          //VerticalGap(gap: 4,),
          Visibility(
              visible: showEndTime,
              child: NormalText(
                endTime,
                color: kTertiaryText,
                fontSize: 10,
              ))
        ],
      ),
    );
  }
}
