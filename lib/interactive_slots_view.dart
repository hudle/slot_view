import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3;

import 'Slot_click_listener.dart';
import 'common/date_time_utils.dart';
import 'common/gap_widget.dart';
import 'model/slot_model/slot_model.dart';
import 'widgets/date_item_widget.dart';
import 'widgets/slot_item_widget.dart';
import 'widgets/time_item_widget.dart';

class InteractiveSlotsView extends StatefulWidget {
  final SlotClickListener listener;
  // final List<Slot> griddata= [] ;
  final SlotInfo slotInfo;
  @override
  State<InteractiveSlotsView> createState() => _InteractiveSlotsViewState();

  InteractiveSlotsView(this.listener, this.slotInfo);
}

class _InteractiveSlotsViewState extends State<InteractiveSlotsView> {
  final TransformationController _transformationController =
      TransformationController();
  static const double _cellWidth = 100;
  static const double _cellHeight = 100;
  Quad? _cachedViewport;
  late int _firstVisibleRow;
  late int _firstVisibleColumn;
  late int _lastVisibleRow;
  late int _lastVisibleColumn;
  bool _isCellVisible(int row, int column, Quad viewport) {
    if (viewport != _cachedViewport) {
      final Rect aabb = _axisAlignedBoundingBox(viewport);
      _cachedViewport = viewport;
      _firstVisibleRow = (aabb.top / _cellHeight).floor();
      _firstVisibleColumn = (aabb.left / _cellWidth).floor();
      _lastVisibleRow = (aabb.bottom / _cellHeight).floor();
      _lastVisibleColumn = (aabb.right / _cellWidth).floor();
    }
    print(
        "First Row: ${_firstVisibleRow}|| First Column: ${_firstVisibleColumn}");
    return row >= _firstVisibleRow &&
        row <= _lastVisibleRow &&
        column >= _firstVisibleColumn &&
        column <= _lastVisibleColumn;
  }

  // Returns the axis aligned bounding box for the given Quad, which might not
  // be axis aligned.
  Rect _axisAlignedBoundingBox(Quad quad) {
    double? xMin;
    double? xMax;
    double? yMin;
    double? yMax;
    for (final Vector3 point in <Vector3>[
      quad.point0,
      quad.point1,
      quad.point2,
      quad.point3
    ]) {
      if (xMin == null || point.x < xMin) {
        xMin = point.x;
      }
      if (xMax == null || point.x > xMax) {
        xMax = point.x;
      }
      if (yMin == null || point.y < yMin) {
        yMin = point.y;
      }
      if (yMax == null || point.y > yMax) {
        yMax = point.y;
      }
    }
    return Rect.fromLTRB(xMin!, yMin!, xMax!, yMax!);
  }

  void _onChangeTransformation() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onChangeTransformation);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onChangeTransformation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SingleChildScrollView(
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
                            onDateTap: () {},
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
              children: [
                SingleChildScrollView(
                    child: timeColumn(widget.slotInfo.timings)),
                Expanded(
                  child: Center(
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return InteractiveViewer.builder(
                          onInteractionUpdate: (details) {},
                          alignPanAxis: true,
                          scaleEnabled: false,
                          transformationController: _transformationController,
                          builder: (BuildContext context, Quad viewport) {
                            // A simple extension of Table that builds cells.
                            return _TableBuilder(
                                rowCount: widget.slotInfo.dates.length,
                                columnCount: widget.slotInfo.timings.length,
                                cellWidth: _cellWidth,
                                builder: (BuildContext context, int row,
                                    int column) {
                                  if (!_isCellVisible(row, column, viewport)) {
                                    debugPrint('removing cell ($row, $column)');
                                    return Container(height: _cellHeight);
                                  }
                                  debugPrint('building cell ($row, $column)');
                                  return Container(
                                    //  margin: const EdgeInsets.all(5),
                                    height: _cellHeight,
                                    color: Colors.white,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Center(
                                        child: SlotItem(
                                            onSlotSelect: () {},
                                            slot: Slot(
                                                availableCount: 10,
                                                basePrice: 40,
                                                startTime: convertFormat(
                                                    time: widget.slotInfo
                                                        .timings[9].from,
                                                    newFormat: API_FORMAT,
                                                    oldFormat: SLOT_TIMING),
                                                endTime: convertFormat(
                                                    time: widget
                                                        .slotInfo.timings[9].to,
                                                    newFormat: API_FORMAT,
                                                    oldFormat: SLOT_TIMING),
                                                slotDate: widget
                                                    .slotInfo.dates[9].date,
                                                isAvailable: true,
                                                price: 0.0,
                                                totalCount: 0)),
                                      ),
                                    ),
                                  );
                                });
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )

          /* Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VerticalGap(
                  gap: 12,
                ),
                // timeColumn(widget.slotInfo.timings),

              ],
            ),
          )*/
        ],
      ),
    );
  }

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
}

typedef _CellBuilder = Widget Function(
    BuildContext context, int row, int column);

class _TableBuilder extends StatelessWidget {
  const _TableBuilder({
    required this.rowCount,
    required this.columnCount,
    required this.cellWidth,
    required this.builder,
  })  : assert(rowCount > 0),
        assert(columnCount > 0);

  final int rowCount;
  final int columnCount;
  final double cellWidth;
  final _CellBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Table(
      // ignore: prefer_const_literals_to_create_immutables
      columnWidths: <int, TableColumnWidth>{
        for (int column = 0; column < columnCount; column++)
          column: FixedColumnWidth(cellWidth),
      },
      // ignore: prefer_const_literals_to_create_immutables
      children: <TableRow>[
        for (int row = 0; row < rowCount; row++)
          // ignore: prefer_const_constructors
          TableRow(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              for (int column = 0; column < columnCount; column++)
                builder(context, row, column),
            ],
          ),
      ],
    );
  }
}
