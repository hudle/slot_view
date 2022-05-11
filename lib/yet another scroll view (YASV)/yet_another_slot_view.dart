import 'package:flutter/material.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_slots_view/yet%20another%20scroll%20view%20(YASV)/date_header.dart';
import 'package:hudle_slots_view/yet%20another%20scroll%20view%20(YASV)/slot_view_body.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class YetAnotherslotsView extends StatefulWidget {
  final SlotInfo info;
  @override
  State<YetAnotherslotsView> createState() => _YetAnotherslotsViewState();

  YetAnotherslotsView(this.info);
}

class _YetAnotherslotsViewState extends State<YetAnotherslotsView> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateHeader(
          scrollController: _headController,
          dates: widget.info.dates,
        ),
        Expanded(
          child: SlotsViewBody(
            date: widget.info.dates,
            slotTiming: widget.info.timings,
            slots: widget.info.slots,
            scrollController: _bodyController,
          ),
        ),
      ],
    );
  }
}
