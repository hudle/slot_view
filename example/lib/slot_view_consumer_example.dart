import 'package:flutter/material.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_slots_view/slot_views/slot_view_consumer.dart';
import 'package:hudle_slots_view/slot_views/slot_view_days.dart';

class SlotViewConsumerDailyViewExample extends StatelessWidget {
  final SlotInfo slotInfo;

  const SlotViewConsumerDailyViewExample(this.slotInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConsumerSlotView(
          isDailyView: true,
          slotInfo: slotInfo,
          selectedDate: '21st May 2022',
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



class SlotViewConsumer4DayViewExample extends StatelessWidget {
  final SlotInfo slotInfo;

  const SlotViewConsumer4DayViewExample(this.slotInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConsumerSlotView(
          isDailyView: false,
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
