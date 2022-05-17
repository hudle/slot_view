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
  final Widget? icon;

  const TimeItem(
      {Key? key,
      this.startTime = "12:00 AM",
      this.endTime = "01:00 AM",
      this.showEndTime = true,
        this.icon,
      })
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
          bottom: SlotInfo.slotHeight * 0.05,
          top: SlotInfo.slotHeight * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NormalText(
                startTime,
                color: kTertiaryText,
                fontSize: 10,
              ),
              if (icon != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 10,
                  width: 10,
                  child: icon!,
                )
            ],
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
