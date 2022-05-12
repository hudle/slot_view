import 'package:flutter/material.dart';
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';
import 'package:hudle_slots_view/slot_builder/widget/empty_box.dart';

import '../common/date_time_utils.dart';
import '../matrix_builder/matrix_builder.dart';
import '../model/slot_model/slot_model.dart' as sf;
import '../widgets/date_item_widget.dart';
import '../widgets/slot_item_widget.dart';
import '../widgets/time_item_widget.dart';


class SlotViewBuilder<H, T, S> extends StatefulWidget {
  final List<H> headers;
  final List<T> columns;
  final FillBoxCallback<H,T,S> fillBoxCallback;
  final SlotBuilder<S> slotBuilder;
  final TimeBuilder<T> timeBuilder;
  final HeaderBuilder<H> headerBuilder;
  final EmptyBoxBuilder? emptyBoxBuilder;
  final double slotHeight;
  final double slotWidth;

  const SlotViewBuilder({
    Key? key,
    required this.headers,
    required this.columns,
    required this.fillBoxCallback,
    required this.slotBuilder,
    required this.timeBuilder,
    required this.headerBuilder,
    this.emptyBoxBuilder,
    this.slotHeight = 100,
    this.slotWidth = 100
  }) : super(key: key);

  @override
  State<SlotViewBuilder<H, T, S>> createState() => _SlotViewBuilderState<H, T, S>();
}

class _SlotViewBuilderState<H, C, S> extends State<SlotViewBuilder<H,C,S>> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MatrixBuilder(
          cellWidth: widget.slotWidth,
          cellHeight: widget.slotHeight,
          cellBuilder: (_, int row, int column) {
            final timeData = widget.columns[column];
            final headerData = widget.headers[row];
            S? slot = widget.fillBoxCallback(headerData, timeData);
            if (slot != null) {
              return widget.slotBuilder(slot);
            }
            else {
              return widget.emptyBoxBuilder?.call() ?? const EmptyBox();
            }

          },
          columnBuilder: (_, int column) {
            final timeData = widget.columns[column];
            return widget.timeBuilder(timeData);

          },
          headBuilder: (_, int row) {
            final headerData = widget.headers[row];
            return widget.headerBuilder(headerData);
          },
          columnCount: widget.columns.length,
          rowCount: widget.headers.length,
        ),
      ),
    );
  }
}

typedef FillBoxCallback<H,C,S> = S? Function(H header, C column);
typedef SlotBuilder<S> = Widget Function(S slot);
typedef EmptyBoxBuilder = Widget Function();
typedef TimeBuilder<C> = Widget Function(C column);
typedef HeaderBuilder<H> = Widget Function(H header);
