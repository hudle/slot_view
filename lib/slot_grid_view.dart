

import 'package:flutter/material.dart';
import 'package:hudle_core/hudle_core.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_theme/hudle_theme.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'Slot_click_listener.dart';
import 'common/date_time_utils.dart';
import 'common/gap_widget.dart';
import 'common/utils.dart';
import 'hudle_slot_view.dart';
//import 'model/slot.dart';

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
  int forloopCount =0;

  int totalFor=0;

  @override
  Widget build(BuildContext context) {
  // getGridData(data);
    return Container(

      child: Column(
        children: [
          SingleChildScrollView(
            controller: _date,

            //INFO: Date Row
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.slotInfo.dates.map((slotData) {
                final mainIndex = widget.slotInfo.dates.indexOf(slotData);
               // final width = (MediaQuery.of(context).size.width/controller.slotDataLength).ceil().toDouble()-24;
                final width = (MediaQuery.of(context).size.width/4).ceil().toDouble()-24;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (mainIndex == 0) const SizedBox(
                      width: 50,
                    ),
                    Container(
                      //color: Colors.red,
                      margin: const EdgeInsets.only(left: 4),
                      width: width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            VerticalGap(),
                            DateItem(
                              day: convertFormat(
                                  time: slotData.date,
                                  newFormat: 'EEE',
                                  oldFormat: API_DATE_FORMAT),
                              date: convertFormat(
                                  time: slotData.date,
                                  newFormat: 'dd',
                                  oldFormat: API_DATE_FORMAT),
                              onDateTap: () {

                              },
                            ),
                            VerticalGap(),
                          ]),
                    ),
                  ],
                );
              }).toList(),
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

                  child:GridView.builder(
                      controller: _grid,shrinkWrap:true,scrollDirection: Axis.horizontal,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.slotInfo.timings.length,
                    crossAxisSpacing:3,
                    mainAxisSpacing: 3,

                  ),itemCount: widget.slotInfo.dates.length*widget.slotInfo.timings.length, itemBuilder: (BuildContext context,index)
                  {
                    int row = (index~/widget.slotInfo.timings.length);
                    int column = (index%widget.slotInfo.timings.length);
                    print("Column $row|| Row $column || Index $index");

                    Widget test = Container(child: Center(child: Text("N/A"),),);
                    bool foundSlot = false;
                    var stime =  widget.slotInfo.timings[column].from;
                    var etime = widget.slotInfo.timings[column].to;
                    var date = widget.slotInfo.dates[row].date;
                    forloopCount=0;

                    for(Slot s in widget.slotInfo.slots[date]!)
                      {
                        forloopCount++;
                        if(s.slotDate==date &&  s.startTime.contains(stime))
                          {

                            foundSlot = true;
                            test= SlotItem(slot: s,slotHeight: index==6?MAX_BOX_SIZE*2:MAX_BOX_SIZE,);
                          }

                        if (foundSlot) {
                          break;
                        }
                      }
                    if(!foundSlot) {
                      test= SlotItem(onSlotSelect:(){},slot: Slot(startTime: convertFormat(time: stime, newFormat: API_FORMAT, oldFormat: SLOT_TIMING),endTime: convertFormat(time: etime, newFormat: API_FORMAT, oldFormat: SLOT_TIMING),slotDate: date,isAvailable: false, price: 0.0, totalCount: 0));
                    }
                    totalFor+=forloopCount;
                    print("FOR LOOP : $forloopCount|| index : $index || totalFor : $totalFor");
                    return test;

                  }
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget timeColumn(List<Timing> timings) => Column(
   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: timings.map((time) {

      final index = timings.indexOf(time);
      final itemCount = timings.length;
        print(time.from.runtimeType);
      final s = convertFormat(
          time:time.from,
          newFormat: DISPLAY_TIME,
          oldFormat: SLOT_TIMING);

      final e = convertFormat(
          time:time.to ,
          newFormat: DISPLAY_TIME,
          oldFormat: SLOT_TIMING);

      final endDate = index == itemCount - 1 || (index + 1 < itemCount) &&
          time.to != timings[index + 1].from;

      return TimeItem(
        showEndTime: endDate,
        startTime: s,
        endTime: e,
      );
    }).toList() ,
  );
}

class DateItem extends StatelessWidget {
  const DateItem({Key? key, this.date = "24", this.day = "Mon", this.onDateTap})
      : super(key: key);

  final String date;
  final String day;

  final VoidCallback? onDateTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDateTap,
      child: Container(
        child: Column(
          children: [
            NormalText(
              date,
              color: kSecondaryText,
              fontSize: 18, fontWeight: FontWeight.bold,
            ),
            VerticalGap(gap: 2,),
            NormalText(
              day,
              color: kSecondaryText,
              fontSize: 12, fontWeight: FontWeight.normal,
            )
          ],
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.only(left: 8,right: 2),
      height: 70,
      width: 40,
      //color: kColorError,
      margin: const EdgeInsets.only(right: 8, bottom: 2, top: 2),
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


class SlotItem extends StatelessWidget {

  final Slot slot;
  final double slotWidth;
  final double slotHeight;
  final Function? onSlotSelect;
  final bool isSlotSelected;
  final Color partialBookedColor;
  final Color availableColor;
  final Color bookedColor;
  final Color notAvailableColor;
  final Color partialBookedTextColor;
  final Color availableTextColor;
  final Color bookedTextColor;
  final Color notAvailableTextColor;
  final Color selectedColor;
  final Color bookedSelectedColor;
  final Color selectedTextColor;

  SlotItem({Key? key, required this.slot,
    this.isSlotSelected = false,
    this.slotWidth = MAX_BOX_SIZE,
    this.slotHeight = MAX_BOX_SIZE,
    this.partialBookedColor = const Color(0xffe1fffc),
    this.partialBookedTextColor = kColorAccent,
    this.bookedColor = kColorLegendBooked,
    this.bookedTextColor = kColorWhite,
    this.availableColor = kColorWhite,
    this.availableTextColor = kSecondaryText,
    this.notAvailableColor = kColorLegendNotAvailable,
    this.notAvailableTextColor = kColorLegendNotAvailable,
    this.selectedColor = kColorLegendSelected,
    this.selectedTextColor = kPrimaryText,
    this.bookedSelectedColor = const Color(0XFF396295),
    this.onSlotSelect
  })
      : super(key: key);

  bool checkTime(String time) {
    return DateFormat(API_FORMAT).parse(time).isAfter(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {

    final isAvailable = checkTime(slot.endTime) && slot.isAvailable == true && (slot.availableCount ?? 0) > 0;
    final isPartialBooked = (slot.availableCount ?? 0) < (slot.totalCount ?? 0)  && isAvailable;
    final isBooked =  slot.isBooked == true;
    final isSelected = isSlotSelected;
    final isSelectedAndBooked = isSlotSelected && isBooked && !isPartialBooked;

    final slotColor = isSelectedAndBooked ? bookedSelectedColor : isSelected ? selectedColor : isPartialBooked ? partialBookedColor : isBooked ? bookedColor : isAvailable == false ? notAvailableColor  : availableColor;
    final textColor = isSelectedAndBooked ? bookedTextColor : isSelected ? selectedTextColor : isPartialBooked ? partialBookedTextColor : isBooked ? bookedTextColor : isAvailable == false ? notAvailableTextColor : availableTextColor;

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: const EdgeInsets.all(2),
      width: slotWidth,
      height: slotHeight,
      decoration: BoxDecoration(color: slotColor, borderRadius:
      BorderRadius.circular(isSelected ? 8 : 0)),
      child: InkWell(
        onTap: () {
          onSlotSelect?.call(slot);
        } ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
                visible: isAvailable || isBooked,
                child: NormalText(getDisplayNumber(slot.price ?? 0, isBooking: false,showSymbol: true), fontSize: 14 , color: textColor, fontWeight: FontWeight.w500,)),
            VerticalGap(gap: 4,),
            Visibility(
                visible: (!isBooked && isPartialBooked) || isAvailable ,

                child: NormalText(getDisplayNumber(slot.availableCount, isBooking: true,compact: true) + " left", fontSize: isSelected ? 12 : 11, color: textColor,)
            ),
          ],
        ),
      ),
    );
  }
}


