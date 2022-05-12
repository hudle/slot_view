import 'package:flutter/material.dart';
import 'package:hudle_slots_view/Slot_click_listener.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_slots_view/slot_builder/slot_view_builder.dart';
import 'package:hudle_slots_view/slot_builder/widget/header_item_widget.dart';
import 'package:hudle_slots_view/widgets/slot_item_widget.dart';
import 'package:hudle_slots_view/widgets/time_item_widget.dart';
import 'package:hudle_theme/hudle_theme.dart';

import '../common/date_time_utils.dart';

class DaySlotView extends StatefulWidget {
  final SlotInfo slotInfo;
  final Function(List<Slot> slots) onSlotSelected;
  final Function? onNext;
  final Function? onPrevious;
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
  final double slotHeight;
  final double slotWidth;
  final EmptyBoxBuilder? emptyBoxBuilder;

  const DaySlotView({
    Key? key,
    required this.slotInfo,
    required this.onSlotSelected,
    this.onNext,
    this.onPrevious,
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
    this.slotHeight = 100,
    this.slotWidth = 100,
    this.emptyBoxBuilder,
  }) : super(key: key);

  @override
  State<DaySlotView> createState() => _DaySlotViewState();
}

class _DaySlotViewState extends State<DaySlotView> {
  Map<String, Set<Slot>> selectedSlots = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SlotViewBuilder<SlotDate, Timing, Slot>(
          slotHeight: widget.slotHeight,
          slotWidth: widget.slotWidth,
          columns: widget.slotInfo.timings,
          headers: widget.slotInfo.dates,
          emptyBoxBuilder: widget.emptyBoxBuilder,
          fillBoxCallback: (SlotDate slotDate, Timing timing) {
            final startTime = timing.from;
            final date = slotDate.date;

            final slots = widget.slotInfo.slots[date] ?? [];
            for (Slot s in slots) {
              if (s.slotDate == date && s.startTime.contains(startTime)) {
                return s;
              }
            }

            return null;
          },
          headerBuilder: (slotDate) {
            final title = convertFormat(
                time: slotDate.date,
                newFormat: 'EEE',
                oldFormat: API_DATE_FORMAT);

            final subtitle = convertFormat(
                time: slotDate.date,
                newFormat: 'dd',
                oldFormat: API_DATE_FORMAT);

            return HeaderItem(
              title: title,
              subtitle: subtitle,
              onTap: () {
                _selectDates(slotDate.date);
              },
            );
          },
          slotBuilder: (slot) {
            return SlotItem(
              availableColor: widget.availableColor,
              availableTextColor: widget.availableTextColor,
              bookedColor: widget.bookedColor,
              bookedSelectedColor: widget.bookedSelectedColor,
              bookedTextColor: widget.bookedTextColor,
              notAvailableColor: widget.notAvailableColor,
              notAvailableTextColor: widget.notAvailableTextColor,
              partialBookedColor: widget.partialBookedColor,
              partialBookedTextColor: widget.partialBookedTextColor,
              selectedColor: widget.selectedColor,
              selectedTextColor: widget.selectedTextColor,
              isSlotSelected: isSelected(slot, slot.slotDate),
              onSlotSelect: setSelection,
              slot: slot,
            );
          },
          timeBuilder: (time) {
            final index = widget.slotInfo.timings.indexOf(time);
            final itemCount = widget.slotInfo.timings.length;

            final s = convertFormat(
                time: time.from,
                newFormat: DISPLAY_TIME,
                oldFormat: SLOT_TIMING);

            final e = convertFormat(
                time: time.to, newFormat: DISPLAY_TIME, oldFormat: SLOT_TIMING);

            final endDate = index == itemCount - 1 ||
                (index + 1 < itemCount) &&
                    time.to != widget.slotInfo.timings[index + 1].from;

            return TimeItem(
              showEndTime: endDate,
              startTime: s,
              endTime: e,
            );
          },
        ),
      ),
    );
  }

  void setSelection(Slot slot, String date) {
    debugPrint('${slot.isAvailable}');
    if (slot.isAvailable == null || slot.isAvailable == false) {
      return;
    }
    if (isSelected(slot, date)) {
      selectedSlots[date]?.remove(slot);
    } else {
      if (selectedSlots[date] == null) {
        selectedSlots[date] = {slot};
      } else {
        selectedSlots[date]?.add(slot);
      }
    }
    setState(() {});
    _notifySelection();
  }

  bool isSelected(slot, String date) {
    return selectedSlots[date]?.contains(slot) ?? false;
  }

  void _selectDates(String date) {
    List<Slot> slots = widget.slotInfo.slots[date] ?? [];
    if (selectedSlots[date] == null) {
      selectedSlots[date] = slots.toSet();
    } else {
      if (selectedSlots[date]!.containsAll(slots)) {
        selectedSlots[date]!.clear();
      } else {
        selectedSlots[date]!.addAll(slots);
      }
    }
    setState(() {});
    print(' selected length :${selectedSlots[date]!.length}');

    _notifySelection();
  }

  void _notifySelection() {
    final list = <Slot>[];
    selectedSlots.forEach((key, value) {
      list.addAll(value);
    });
    widget.onSlotSelected(list);
  }
}
