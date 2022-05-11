// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:hudle_core/hudle_core.dart';
// Project imports:
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_theme/hudle_theme.dart';
import 'package:intl/intl.dart';

import '../common/date_time_utils.dart';
import '../common/gap_widget.dart';
import '../common/utils.dart';

const MAX_BOX_SIZE = 70.0;

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

  SlotItem(
      {Key? key,
      required this.slot,
      this.isSlotSelected = false,
      this.slotWidth = SlotInfo.slotWidth,
      this.slotHeight = SlotInfo.slotHeight,
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
      this.onSlotSelect})
      : super(key: key);

  bool checkTime(String time) {
    return DateFormat(API_FORMAT).parse(time).isAfter(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = checkTime(slot.endTime) &&
        slot.isAvailable == true &&
        (slot.availableCount ?? 0) > 0;
    final isPartialBooked =
        (slot.availableCount ?? 0) < (slot.totalCount ?? 0) && isAvailable;
    final isBooked = slot.isBooked == true;
    final isSelected = isSlotSelected;
    final isSelectedAndBooked = isSlotSelected && isBooked && !isPartialBooked;

    final slotColor = isSelectedAndBooked
        ? bookedSelectedColor
        : isSelected
            ? selectedColor
            : isPartialBooked
                ? partialBookedColor
                : isBooked
                    ? bookedColor
                    : isAvailable == false
                        ? notAvailableColor
                        : availableColor;
    final textColor = isSelectedAndBooked
        ? bookedTextColor
        : isSelected
            ? selectedTextColor
            : isPartialBooked
                ? partialBookedTextColor
                : isBooked
                    ? bookedTextColor
                    : isAvailable == false
                        ? notAvailableTextColor
                        : availableTextColor;

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: SlotInfo.slotWidth * 0.10,
          bottom: SlotInfo.slotWidth * 0.05),
      width: slotWidth,
      height: slotHeight,
      decoration: BoxDecoration(
          color: slotColor,
          borderRadius: BorderRadius.circular(isSelected ? 8 : 0)),
      child: InkWell(
        onTap: () {
          onSlotSelect?.call(slot, slot.slotDate);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
                visible: isAvailable || isBooked,
                child: NormalText(
                  getDisplayNumber(slot.price,
                      isBooking: false, showSymbol: true),
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                )),
            VerticalGap(
              gap: 4,
            ),
            Visibility(
                visible: (!isBooked && isPartialBooked) || isAvailable,
                child: NormalText(
                  getDisplayNumber(slot.availableCount,
                          isBooking: true, compact: true) +
                      " left",
                  fontSize: isSelected ? 12 : 11,
                  color: textColor,
                )),
          ],
        ),
      ),
    );
  }
}
