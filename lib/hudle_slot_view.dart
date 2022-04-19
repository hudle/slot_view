library hudle_slot_view;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudle_core/hudle_core.dart';
import 'package:hudle_theme/hudle_theme.dart';
import 'package:intl/intl.dart';
import 'common/legend_view.dart';
import 'common/date_time_utils.dart';
import 'common/utils.dart';
import 'slot_view_controller.dart';
import 'common/swipable.dart';
import 'common/gap_widget.dart';
import 'Slot_click_listener.dart';
import '/model/slot.dart';




const MAX_BOX_SIZE = 80.0;

class SlotsView extends StatelessWidget {
  //late BaseResponse<SlotGrid> response;
  final List<SlotData> data;
  final SlotClickListener listener;


  SlotsView({required this.data,required this.listener}) {
    // response = BaseResponse.fromJson(jsonDecode(slotData));
    // data = response.data!.slotData;
    //TODO : Remove print
    print("SLOT LIST: ${data.length}");
  }

  @override
  Widget build(BuildContext context) {

    final controller = SlotViewController(data);
    Get.put(controller);
if(data.isEmpty)
  {
    return Container(
      child: const Center(
        child: Text("NO DATA"),
      )
    );
  }

    return Container(
      child: Swipable(
        onRightSwipe: listener.onPreviousClick,
        onLeftSwipe: listener.onNextClick,
        child: Container(
          color: Color(0xffF5F5F5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LegendView(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((slotData) {
                  final mainIndex = data.indexOf(slotData);
                  final width = (MediaQuery.of(context).size.width/controller.slotDataLength).ceil().toDouble()-24;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (mainIndex == 0) SizedBox(
                       width: 40,
                      ),
                      Container(
                        //color: Colors.red,
                       margin: const EdgeInsets.only(left: 8),
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
                                  controller.setSelections(slotData.slots,slotData.date);
                                  listener.onSlotSelected2(controller.getAllSlots());
                                },
                              ),
                              VerticalGap(),
                            ]),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.map((slotData) {
                      final mainIndex = data.indexOf(slotData);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (mainIndex == 0) Column(
                            children: [
                              VerticalGap(gap: 12,),
                              // DateItem(
                              //     day: '',
                              //     date: ''
                              // ),
                              VerticalGap(gap: 12,),
                              timeColumn(slotData),
                            ],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                VerticalGap(gap: 12,),
                                // DateItem(
                                //   day: convertFormat(
                                //       time: slotData.date,
                                //       newFormat: 'EEE',
                                //       oldFormat: API_DATE_FORMAT),
                                //   date: convertFormat(
                                //       time: slotData.date,
                                //       newFormat: 'dd',
                                //       oldFormat: API_DATE_FORMAT),
                                //   onDateTap: () {
                                //     controller.setSelections(slotData.slots,slotData.date);
                                //     listener.onSlotSelected2(controller.getAllSlots());
                                //   },
                                // ),
                                VerticalGap(gap: 12,),
                                Column(

                                  children: slotData.slots.map((slot) {
                                    return Obx(
                                          () => Padding(
                                        padding: const EdgeInsets.only(left: 1,right: 1,bottom: 1),
                                        child: SlotItem(
                                          slot: slot,
                                          onSlotSelect: (slot) {

                                            controller.setSelection(slot,slotData.date);
                                            listener.onSlotSelected2(controller.getAllSlots());
                                          },
                                          isSlotSelected: controller.isSelected(slot,slotData.date),
                                          slotWidth: (MediaQuery.of(context).size.width/controller.slotDataLength).ceil().toDouble()-24,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              ]),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget timeColumn(SlotData slotData) => Column(
    children: slotData.slots.map((slot) {

      final index = slotData.slots.indexOf(slot);
      final itemCount = slotData.slots.length;

      final s = convertFormat(
          time: slot.startTime,
          newFormat: DISPLAY_TIME,
          oldFormat: API_FORMAT);

      final e = convertFormat(
          time: slot.endTime,
          newFormat: DISPLAY_TIME,
          oldFormat: API_FORMAT);

      final endDate = index == itemCount - 1 || (index + 1 < itemCount) &&
          slot.endTime != slotData.slots[index + 1].startTime;

      return TimeItem(
        showEndTime: endDate,
        startTime: s,
        endTime: e,
      );
    }).toList() ,
  );
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
                child: NormalText(getDisplayNumber(slot.price, isBooking: false,showSymbol: true), fontSize: 14 , color: textColor, fontWeight: FontWeight.w500,)),
            VerticalGap(gap: 4,),
            Visibility(
                visible: (!isBooked && isPartialBooked) || isAvailable ,
                child: NormalText(getDisplayNumber(slot.availableCount, isBooking: true,compact: true) + " left", fontSize: isSelected ? 12 : 11, color: textColor,)),
          ],
        ),
      ),
    );
  }
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
      height: MAX_BOX_SIZE,
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




