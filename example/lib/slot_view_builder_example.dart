import 'package:flutter/material.dart';
import 'package:hudle_slots_view/Slot_click_listener.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_slots_view/slot_builder/slot_view_builder.dart';
import 'package:hudle_slots_view/slot_builder/slot_view_days.dart';

class SlotViewBuilderExample extends StatelessWidget {
  final SlotInfo slotInfo;

  const SlotViewBuilderExample(this.slotInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DaySlotView(
          slotInfo: slotInfo,
          onSlotSelected: (slots) {
            print(
              "Selected Slot ${slots}",
            );
          },
        ),
      ),
    );
  }
}
