import 'package:flutter/material.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_slots_view/widgets/date_item_widget.dart';

import '../common/date_time_utils.dart';

class DateHeader extends StatelessWidget {
  final ScrollController scrollController;
  final List<SlotDate> dates;
  final tileHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tileHeight,
      child: Row(
        children: [
          const SizedBox(
            height: SlotInfo.slotHeight,
            width: SlotInfo.timeWidth,
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                dates.length,
                (index) {
                  return Container(
                    height: SlotInfo.slotHeight,
                    width: SlotInfo.slotWidth,
                    margin: const EdgeInsets.only(left: 5, right: 5),

                    //margin: const EdgeInsets.only(left: 20, right: 20),
                    child: DateItem(
                      day: convertFormat(
                          time: dates[index].date,
                          newFormat: 'EEE',
                          oldFormat: API_DATE_FORMAT),
                      date: convertFormat(
                          time: dates[index].date,
                          newFormat: 'dd',
                          oldFormat: API_DATE_FORMAT),
                      onDateTap: () {},
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  DateHeader({required this.scrollController, required this.dates});
}
