import 'package:flutter/material.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_slots_view/widgets/slot_item_widget.dart';
import 'package:hudle_slots_view/widgets/time_item_widget.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../common/date_time_utils.dart';

class SlotsViewBody extends StatefulWidget {
  final ScrollController scrollController;
  final List<Timing> slotTiming;
  final List<SlotDate> date;

  //Info: Slot Date : List<Slots>
  final Map<String, List<Slot>> slots;

  @override
  State<SlotsViewBody> createState() => _SlotsViewBodyState();

  SlotsViewBody(
      {required this.scrollController,
      required this.slotTiming,
      required this.date,
      required this.slots});
}

class _SlotsViewBodyState extends State<SlotsViewBody> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  final cellWidth = SlotInfo.slotWidth + 10.0;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: SlotInfo.timeWidth,
          child: ListView(
            controller: _firstColumnController,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            children: widget.slotTiming.map((time) {
              final index = widget.slotTiming.indexOf(time);
              final itemCount = widget.slotTiming.length;
              print(time.from.runtimeType);
              final s = convertFormat(
                  time: time.from,
                  newFormat: DISPLAY_TIME,
                  oldFormat: SLOT_TIMING);

              final e = convertFormat(
                  time: time.to,
                  newFormat: DISPLAY_TIME,
                  oldFormat: SLOT_TIMING);

              final endDate = index == itemCount - 1 ||
                  (index + 1 < itemCount) &&
                      time.to != widget.slotTiming[index + 1].from;

              return TimeItem(
                showEndTime: endDate,
                startTime: s,
                endTime: e,
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: (widget.slots.length) * cellWidth,
              child: ListView(
                  controller: _restColumnsController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: List.generate(
                    widget.slotTiming.length,
                    (column) {
                      var startTime = widget.slotTiming[column].from;
                      var endTime = widget.slotTiming[column].to;
                      return Row(
                        children: List.generate(widget.slots.length, (row) {
                          Widget test = Container(
                            child: Center(
                              child: Text("N/A"),
                            ),
                          );
                          bool foundSlot = false;
                          var date = widget.date[row].date;
                          for (Slot s in widget.slots[date]!) {
                            if (s.slotDate == date &&
                                s.startTime.contains(startTime)) {
                              foundSlot = true;
                              test = SlotItem(
                                //onSlotSelect: setSelection,
                                // isSlotSelected: isSelected(s, date),
                                slot: s,
                                /*slotHeight:
                                index == 6 ? MAX_BOX_SIZE * 2 : MAX_BOX_SIZE,*/
                              );
                            }

                            if (foundSlot) {
                              break;
                            }
                          }
                          if (!foundSlot) {
                            test = SlotItem(
                                onSlotSelect: () {},
                                slot: Slot(
                                    startTime: convertFormat(
                                        time: startTime,
                                        newFormat: API_FORMAT,
                                        oldFormat: SLOT_TIMING),
                                    endTime: convertFormat(
                                        time: endTime,
                                        newFormat: API_FORMAT,
                                        oldFormat: SLOT_TIMING),
                                    slotDate: date,
                                    isAvailable: false,
                                    price: 0.0,
                                    totalCount: 0));
                          }
                          return test;

                          /*Container(
                            child: Center(child: Text("$column*$row")),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, top: 10, bottom: 5),
                            height: 70,
                            width: 70,
                          );*/
                        }),
                      );
                    },
                  )),
            ),
          ),
        )
      ],
    );
  }
}
