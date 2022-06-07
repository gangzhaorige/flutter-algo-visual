import 'package:flutter/widgets.dart';

class GridGestureDetector extends StatefulWidget {

  const GridGestureDetector({
    Key? key, 
    required this.child, 
    required this.width,
    required this.height, 
    required this.unitSize,
    required this.rows,
    required this.columns,
    required this.onTapNode,
    required this.onDragNode,
  }) : super(key: key);
  
  final int rows;
  final int columns;
  final double unitSize;
  final double width;
  final double height;
  final Widget child;

  final Function(int i, int j) onTapNode;
  final Function(int i, int j, int newI, int newJ) onDragNode;

  @override
  State<GridGestureDetector> createState() => _GridGestureDetectorState();
}

class _GridGestureDetectorState extends State<GridGestureDetector> {

  int row = 0;
  int column = 0;

  int getIndex(double gridSize, double position, int maxSize){
    var numb = position / gridSize;
    int pos = numb.floor().clamp(0, maxSize);
    return pos;
  }

  void dragUpdate(var details){
    var newRow = getIndex(widget.unitSize, details.dx, widget.rows - 1);
    var newColumn = getIndex(widget.unitSize, details.dy, widget.columns - 1);
    if (newRow != row || newColumn != column) {
      widget.onDragNode(row, column, newRow, newColumn);
    }
    row = newRow;
    column = newColumn;
  }

  void tapUpdate(var details){
    row = getIndex(widget.unitSize, details.dx, widget.rows - 1);
    column = getIndex(widget.unitSize, details.dy, widget.columns - 1);
    widget.onTapNode(row, column);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressMoveUpdate: (details) {
        dragUpdate(details.localPosition);
      },
      onScaleUpdate: (details) {
        if (details.scale == 1.0) {
          dragUpdate(details.localFocalPoint);
        }
      },
      onTapDown: (details) {
        tapUpdate(details.localPosition);
      },
      onScaleStart: (details) {
        tapUpdate(details.localFocalPoint);
      },
      onLongPressStart: (details){
        tapUpdate(details.localPosition);
      },
      child: widget.child
    );
  }
}