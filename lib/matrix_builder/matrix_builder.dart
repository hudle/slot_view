import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class MatrixBuilder extends StatefulWidget {
  final CellBuilder cellBuilder;
  final int rowCount;
  final int columnCount;
  final HeadBuilder headBuilder;
  final ColumnBuilder columnBuilder;
  final double cellWidth;
  final double cellHeight;
  final double headerHeight;
  final double headerWidth;
  final double columnWidth;

  const MatrixBuilder(
      {required this.cellBuilder,
      required this.rowCount,
      required this.columnCount,
      required this.headBuilder,
      required this.columnBuilder,
      this.cellWidth = 80.0,
      this.cellHeight = 80.0,
      this.headerHeight = 40.0,
      this.headerWidth = 80.0,
      this.columnWidth = 50.0});

  @override
  State<MatrixBuilder> createState() => _MatrixBuilderState();
}

class _MatrixBuilderState extends State<MatrixBuilder> {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          headerHeight: widget.headerHeight,
          tileWidth: widget.headerWidth,
          columnWidth: widget.columnWidth,
          scrollController: _headController,
          count: widget.rowCount,
          headBuilder: widget.headBuilder,
          cellWidth: widget.cellWidth,
        ),
        Expanded(
          child: CellWidget(
            cellWidth: widget.cellWidth,
            cellHeight: widget.cellHeight,
            columnWidth: widget.columnWidth,
            rowCount: widget.rowCount,
            columnCount: widget.columnCount,
            // slots: widget.info.slots,
            scrollController: _bodyController,
            cellBuilder: widget.cellBuilder,
            columnBuilder: widget.columnBuilder,
          ),
        ),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final ScrollController scrollController;
  final int count;
  final HeadBuilder headBuilder;
  final double headerHeight;
  final double tileWidth;
  final double columnWidth;
  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      height: headerHeight,
      child: Row(
        children: [
          SizedBox(
            height: headerHeight,
            width: columnWidth,
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                count,
                (index) {
                  return SizedBox(
                      width: cellWidth,
                      child: headBuilder(context, index));
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  const HeaderWidget(
      {required this.scrollController,
      required this.count,
      required this.headBuilder,
      required this.headerHeight,
      required this.tileWidth,
      required this.columnWidth,
      required this.cellWidth,});
}

class CellWidget extends StatefulWidget {
  final ScrollController scrollController;
  final int columnCount;
  final int rowCount;
  final CellBuilder cellBuilder;
  final ColumnBuilder columnBuilder;
  final double columnWidth;
  final double cellWidth;
  final double cellHeight;

  //Info: Slot Date : List<Slots>
  // final Map<String, List<Slot>> slots;

  @override
  State<CellWidget> createState() => _CellWidgetState();

  CellWidget({
    required this.scrollController,
    required this.columnCount,
    required this.rowCount,
    required this.cellBuilder,
    required this.columnBuilder,
    required this.columnWidth,
    required this.cellWidth,
    required this.cellHeight,
  });
}

class _CellWidgetState extends State<CellWidget> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.columnWidth,
          child: ListView(
            controller: _firstColumnController,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            children: List.generate(widget.columnCount,
                (index) => SizedBox(
                  height: widget.cellHeight,
                  child: widget.columnBuilder(context, index),
                ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width:widget.cellWidth * widget.rowCount + 10,
              child: ListView(
                  controller: _restColumnsController,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: List.generate(
                    widget.columnCount,
                    (column) {
                      return Row(
                        children: List.generate(widget.rowCount, (row) {
                          return SizedBox(
                            width: widget.cellWidth,
                            height: widget.cellHeight,
                            child: widget.cellBuilder(context, row, column),
                          );
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

typedef CellBuilder = Widget Function(BuildContext, int row, int column);
typedef HeadBuilder = Widget Function(BuildContext, int row);
typedef ColumnBuilder = Widget Function(BuildContext, int column);
