// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
// Package imports:

import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'Slot_click_listener.dart';
import 'common/date_time_utils.dart';
import 'common/gap_widget.dart';
import 'widgets/date_item_widget.dart';
import 'widgets/slot_item_widget.dart';
import 'widgets/time_item_widget.dart';

class SlotGridView extends StatefulWidget {
  // final SlotGrid data;
  final SlotClickListener listener;
  // final List<Slot> griddata= [] ;
  final SlotInfo slotInfo;

  SlotGridView(this.slotInfo, this.listener);

  @override
  State<SlotGridView> createState() => _SlotGridViewState();
}

class _SlotGridViewState extends State<SlotGridView> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _grid;
  late ScrollController _date;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _grid = _controllers.addAndGet();
    _date = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _grid.dispose();
    _date.dispose();
    super.dispose();
  }

  //const MAX_BOX_SIZE = 80.0;
  int forloopCount = 0;

  int totalFor = 0;

  @override
  Widget build(BuildContext context) {
    // return InteractiveSlotsView(widget.listener, widget.slotInfo);
    //  getGridData(data);
    return Container(
      child: Column(
        children: [
          SingleChildScrollView(
            controller: _date,
            //INFO: Date Row
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 50,
                ),
                ...widget.slotInfo.dates.map((slotDate) {
                  final mainIndex = widget.slotInfo.dates.indexOf(slotDate);
                  // final width = (MediaQuery.of(context).size.width/controller.slotDataLength).ceil().toDouble()-24;
                  final width = (MediaQuery.of(context).size.width / 4)
                          .ceil()
                          .toDouble() -
                      24;

                  return Container(
                    margin: const EdgeInsets.only(left: 4, right: 5),
                    width: 90,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          VerticalGap(),
                          DateItem(
                            day: convertFormat(
                                time: slotDate.date,
                                newFormat: 'EEE',
                                oldFormat: API_DATE_FORMAT),
                            date: convertFormat(
                                time: slotDate.date,
                                newFormat: 'dd',
                                oldFormat: API_DATE_FORMAT),
                            onDateTap: () {
                              onSlotSelection(
                                  widget.slotInfo.slots[slotDate.date]!,
                                  slotDate.date);
                            },
                          ),
                          VerticalGap(),
                        ]),
                  );
                }).toList()
              ],
            ),
          ),
          HorizontalGap(
            gap: 40,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //VerticalGap(gap: 12,),
                timeColumn(widget.slotInfo.timings),
                Expanded(
                  child: GridView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      controller: _grid,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.slotInfo.timings.length,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                      ),
                      itemCount: widget.slotInfo.dates.length *
                          widget.slotInfo.timings.length,
                      itemBuilder: (BuildContext context, index) {
                        int row = (index ~/ widget.slotInfo.timings.length);
                        int column = (index % widget.slotInfo.timings.length);
                        print("Column $row|| Row $column || Index $index");

                        Widget test = Container(
                          child: Center(
                            child: Text("N/A"),
                          ),
                        );
                        bool foundSlot = false;
                        var stime = widget.slotInfo.timings[column].from;
                        var etime = widget.slotInfo.timings[column].to;
                        var date = widget.slotInfo.dates[row].date;
                        forloopCount = 0;

                        for (Slot s in widget.slotInfo.slots[date]!) {
                          forloopCount++;
                          if (s.slotDate == date &&
                              s.startTime.contains(stime)) {
                            foundSlot = true;
                            test = SlotItem(
                              onSlotSelect: setSelection,
                              isSlotSelected: isSelected(s, date),
                              slot: s,
                              slotHeight:
                                  index == 6 ? MAX_BOX_SIZE * 2 : MAX_BOX_SIZE,
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
                                      time: stime,
                                      newFormat: API_FORMAT,
                                      oldFormat: SLOT_TIMING),
                                  endTime: convertFormat(
                                      time: etime,
                                      newFormat: API_FORMAT,
                                      oldFormat: SLOT_TIMING),
                                  slotDate: date,
                                  isAvailable: false,
                                  price: 0.0,
                                  totalCount: 0));
                        }
                        totalFor += forloopCount;
                        print(
                            "FOR LOOP : $forloopCount|| index : $index || totalFor : $totalFor");
                        return test;
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Creates the time slots Column
  Widget timeColumn(List<Timing> timings) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: timings.map((time) {
          final index = timings.indexOf(time);
          final itemCount = timings.length;
          print(time.from.runtimeType);
          final s = convertFormat(
              time: time.from, newFormat: DISPLAY_TIME, oldFormat: SLOT_TIMING);

          final e = convertFormat(
              time: time.to, newFormat: DISPLAY_TIME, oldFormat: SLOT_TIMING);

          final endDate = index == itemCount - 1 ||
              (index + 1 < itemCount) && time.to != timings[index + 1].from;

          return TimeItem(
            showEndTime: endDate,
            startTime: s,
            endTime: e,
          );
        }).toList(),
      );

  Map<String, Set<Slot>> selected = {};
  void setSelection(Slot slot, String date) {
    debugPrint('${slot.isAvailable}');
    if (slot.isAvailable == null || slot.isAvailable == false) {
      return;
    }
    if (isSelected(slot, date)) {
      selected[date]?.remove(slot);
    } else {
      if (selected[date] == null) {
        selected[date] = {slot};
      } else {
        selected[date]?.add(slot);
      }
    }
  }

  void setSelections(List<Slot> slots, String date) {
    if (selected[date] == null) {
      selected[date] = slots.toSet();
    } else {
      if (selected[date]!.containsAll(slots)) {
        selected[date]!.clear();
      } else {
        selected[date]!.addAll(slots);
      }
    }
    print(' selected length :${selected[date]!.length}');
  }

  bool isSelected(slot, String date) {
    return selected[date]?.contains(slot) ?? false;
  }

  void onSlotSelection(List<Slot> slots, String date) {
    setSelections(slots, date);
    print(selected.keys.toList());
  }
}
