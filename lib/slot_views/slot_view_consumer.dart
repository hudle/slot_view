import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudle_core/hudle_core.dart';
import 'package:hudle_slots_view/common/gap_widget.dart';
import 'package:hudle_slots_view/common/legend_view.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_slots_view/slot_builder/flip_card/filp_card.dart';
import 'package:hudle_slots_view/slot_builder/slot_view_builder.dart';
import 'package:hudle_slots_view/slot_builder/widget/header_item_widget.dart';
import 'package:hudle_slots_view/widgets/slot_item_widget.dart';
import 'package:hudle_slots_view/widgets/time_item_widget.dart';
import 'package:hudle_theme/hudle_theme.dart';

import '../common/date_time_utils.dart';
import '../common/utils.dart';

class ConsumerSlotView extends StatefulWidget {
  final SlotInfo slotInfo;
  final Function(List<Slot> slots) onSlotSelected;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final Color partialBookedColor;
  final Color availableColor;
  final Color availableLegendBorderColor;
  final Color bookedColor;
  final Color bookedLegendBorderColor;
  final Color notAvailableColor;
  final Color notAvailableLegendBorderColor;
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
  final bool enableMultiSlot;
  final bool isDailyView;
  final bool hasNext;
  final bool hasPrev;
  final bool showLegend;
  final String? selectedDate;
  final double headerHeight;
  final double timeWidth;


  const ConsumerSlotView({
    Key? key,
    required this.slotInfo,
    required this.onSlotSelected,
    required this.isDailyView,
    this.onNext,
    this.onPrevious,
    this.partialBookedColor = const Color(0xffe1fffc),
    this.partialBookedTextColor = kColorAccent,
    this.bookedColor = const Color(0xFFF16042),
    this.bookedLegendBorderColor = const Color(0xFFF16042),
    this.bookedTextColor = kColorWhite,
    this.availableColor = kColorWhite,
    this.availableLegendBorderColor = const Color(0xFFBBBBBB),
    this.availableTextColor = kSecondaryText,
    this.notAvailableColor = const Color(0xFFDDDDDD),
    this.notAvailableLegendBorderColor = const Color(0xFFDDDDDD),
    this.notAvailableTextColor = kColorLegendNotAvailable,
    this.selectedColor = kColorLegendSelected,
    this.selectedTextColor = kPrimaryText,
    this.bookedSelectedColor = const Color(0XFF396295),
    this.slotHeight = 80,
    this.slotWidth = 80,
    this.emptyBoxBuilder,
    this.enableMultiSlot = false,
    this.hasNext = false,
    this.hasPrev = false,
    this.showLegend = true,
    this.selectedDate,
    this.headerHeight = 40,
    this.timeWidth = 70,
  }) : super(key: key);

  @override
  State<ConsumerSlotView> createState() => _ConsumerSlotViewState();
}

class _ConsumerSlotViewState extends State<ConsumerSlotView> {
  Map<String, Set<Slot>> selectedSlots = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Visibility(
              visible: widget.showLegend,
              child: LegendView(
          data: [
              LegendData(text: 'Booked', color: widget.bookedColor, borderColor: widget.bookedLegendBorderColor),
              LegendData(text: 'Available', color: widget.availableColor, borderColor: widget.availableLegendBorderColor),
              LegendData(text: 'Not Available', color: widget.notAvailableColor, borderColor: widget.notAvailableLegendBorderColor),
              LegendData(text: 'Filling Fast', color: widget.partialBookedColor, borderColor: kColorAccent),
          ],
              ),
            ),
          ),
          Expanded(
            child: SlotViewBuilder<SlotDate, Timing, Slot>(
              slotHeight: widget.slotHeight,
              slotWidth: widget.slotWidth,
              columns: widget.slotInfo.timings,
              headers: widget.slotInfo.dates,
              timingWidth: widget.timeWidth,
              headerHeight: widget.headerHeight,
              emptyBoxBuilder: widget.isDailyView ? () => Container(
                height: MAX_BOX_SIZE,
                width: MAX_BOX_SIZE,
                color: Theme.of(context).scaffoldBackgroundColor,
              ) : widget.emptyBoxBuilder,
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
                if (widget.isDailyView) {
                   return HeaderItem(
                     textSize: 14,
                    maxLines: 2,
                    title: slotDate.date,
                    subtitle: '',
                    onTap: () {
                      _selectDates(slotDate.date);
                    },
                  );
                }

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
                  onTap: null,
                );
              },
              slotBuilder: (slot) {

                 Function(Slot slot, String date)? onSelect;
                   GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
                   const counterSize = 18.0;

                final slotItem =
                InkWell(
                  onLongPress: () {
                    _cardKey.currentState?.toggleCard();
                  },
                  child: SlotItem(
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
                    onSlotSelect: (slot, date) {
                      // if (widget.enableMultiSlot) {
                      //   onSelect?.call(slot, date);
                      // }
                      // else {
                      //   setSelection(slot, date);
                      // }
                      setSelection(slot, date);
                    },
                    slot: slot,
                  ),
                );

                // if (widget.enableMultiSlot){
                //   GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
                //
                //   onSelect = (slot, date) {
                //     _cardKey.currentState?.toggleCard();
                //   };
                //
                //   final counterSize = 18.0;
                //
                //   return FlipCard(
                //       key: _cardKey,
                //       front: slotItem,
                //       back: Container(
                //         decoration: BoxDecoration(
                //           color: kColorLegendSelected,
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //         margin: const EdgeInsets.all(4),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             NormalText(
                //               getDisplayNumber(slot.price,
                //                   compact: false, isBooking: false, showSymbol: true),
                //               fontSize: 14,
                //               color: widget.selectedTextColor,
                //               fontWeight: FontWeight.w500,
                //             ),
                //             VerticalGap(gap: 8,),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: [
                //                 Container(
                //                   height: counterSize,
                //                   width: counterSize,
                //                   decoration: BoxDecoration(
                //                     color: kColorAccent,
                //                     shape: BoxShape.circle,
                //                   ),
                //                   child: Center(child: Text("+", style: TextStyle(color: kColorWhite, fontSize: 18),)),
                //                 ),
                //                 Text("1", style: TextStyle(color: widget.selectedTextColor, fontSize: 14),),
                //                 Container(
                //                   height: counterSize,
                //                   width: counterSize,
                //                   decoration: BoxDecoration(
                //                     color: kColorAccent,
                //                     shape: BoxShape.circle,
                //                   ),
                //                   child: Center(child: Text("-", style: TextStyle(color: kColorWhite, fontSize: 18),)),
                //                 )
                //               ],
                //             ),
                //           ],
                //         ),
                //       )
                //   );
                // }

               // return slotItem;

                 return FlipCard(
                     key: _cardKey,
                     front: slotItem,
                     back: Container(
                       decoration: BoxDecoration(
                         color: kColorLegendSelected,
                         borderRadius: BorderRadius.circular(5),
                       ),
                       margin: const EdgeInsets.all(4),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           NormalText(
                             getDisplayNumber(slot.price,
                                 compact: false, isBooking: false, showSymbol: true),
                             fontSize: 14,
                             color: widget.selectedTextColor,
                             fontWeight: FontWeight.w500,
                           ),
                           VerticalGap(gap: 8,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Container(
                                 height: counterSize,
                                 width: counterSize,
                                 decoration: BoxDecoration(
                                   color: kColorAccent,
                                   shape: BoxShape.circle,
                                 ),
                                 child: Center(child: Text("+", style: TextStyle(color: kColorWhite, fontSize: 18),)),
                               ),
                               Text("1", style: TextStyle(color: widget.selectedTextColor, fontSize: 14),),
                               Container(
                                 height: counterSize,
                                 width: counterSize,
                                 decoration: BoxDecoration(
                                   color: kColorAccent,
                                   shape: BoxShape.circle,
                                 ),
                                 child: Center(child: Text("-", style: TextStyle(color: kColorWhite, fontSize: 18),)),
                               )
                             ],
                           ),
                         ],
                       ),
                     )
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

                bool isEve = isEvening(time.from);
                return TimeItem(
                  showEndTime: endDate,
                  startTime: s,
                  endTime: e,
                  icon: isEve ? SvgPicture.network('https://hudle.in/icons/moon.svg') : SvgPicture.network('https://hudle.in/icons/sun.svg')
                  //Image.network('https://hudle.in/icons/sun.svg'),
                );
              },
            ),
          ),
          Container(
            color: kColorGrey200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: widget.onPrevious, child: Text("Prev")),
                Text(widget.selectedDate ?? ''),
                TextButton(onPressed: widget.onNext, child: Text("Next"))
              ],
            ),
          )
        ],
      ),
    );
  }

  void setSelection(Slot slot, String date) {
    debugPrint('${slot.isAvailable}');
    if (slot.isAvailable == null || slot.isAvailable == false) {
      return;
    }
    if (slot.availableCount == 0){
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

  //HH:mm
  bool isEvening(String time) {
    try {
      final hour = convertFormat(
          time: time,
          newFormat: 'HH',
          oldFormat: SLOT_TIMING);

      final currentHour = double.parse(hour);

      var split_afternoon = 6; //24hr time to split the afternoon
      var split_evening = 17; //24hr time to split the evening

      if (currentHour >= split_afternoon && currentHour <= split_evening) {
        return false;
      } else {
        return true;
      }

    }catch(e) {
      print("Don't know");
      return false;
    }
  }
}
