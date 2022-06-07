
import 'package:flutter/material.dart';

import 'node_model.dart';

class WallNodePainter extends NodePainter{
  WallNodePainter(
    double unitSize,
    double fraction,
    NodeType type,
  ) : super(unitSize, fraction, type);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rectl = Rect.fromCenter(
      center: Offset(unitSize/2,unitSize/2),
      width: fraction * (unitSize + 2),
      height: fraction * (unitSize + 2),
    );
    Paint paint = Paint();
    paint.color = nodeColor[type] as Color;
    canvas.drawRect(rectl, paint);
  }
}

class WallNodePaintWidget extends StatefulWidget {
  const WallNodePaintWidget({
    Key? key,
    required this.unitSize,
    required this.row,
    required this.column,
    required this.type,
    required this.callback
  }) : super(key:key);

  final double unitSize;
  final int row;
  final int column;
  final NodeType type;
  final Function(int row, int column, NodeType type) callback;

  @override
  State<WallNodePaintWidget> createState() => _WallNodePaintWidgetState();
}

class _WallNodePaintWidgetState extends State<WallNodePaintWidget> with SingleTickerProviderStateMixin{
  double fraction = 0;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
    ..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        widget.callback(
          widget.row,
          widget.column,
          widget.type,
        );
      }
    });

    animation = Tween(begin: 0.0, end: 0.96).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut
    ))
    ..addListener((){
      setState(() {
        fraction = animation.value;
      });
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WallNodePainter(widget.unitSize, fraction, widget.type)
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

abstract class NodePainter extends CustomPainter{
  NodePainter(this.unitSize, this.fraction, this.type);
  double fraction;
  double unitSize;
  NodeType type;

  @override
  bool shouldRepaint(NodePainter oldDelegate) {
    return oldDelegate.fraction != fraction ? true : false;
  }
}

class SquareWidget extends StatelessWidget {
  final NodeType type;
  final int row;
  final int col;
  final double unitSize;

  const SquareWidget({
    Key? key,
    required this.type,
    required this.row,
    required this.col,
    required this.unitSize,
  }): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Square(type: type, row: row, col: col, unitSize: unitSize),
    );
  }
}


class Square extends CustomPainter {
  Square({
    required this.type,
    required this.row,
    required this.col,
    required this.unitSize,
  });
  
  final NodeType type;
  final int row;
  final int col;
  final double unitSize;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rectl = Rect.fromCenter(
      center: Offset(unitSize / 2, unitSize / 2),
      width: unitSize * 0.98,
      height: unitSize * 0.98,
    );
    Paint paint = Paint();
    paint.color = nodeColor[type] as Color;
    canvas.drawRect(rectl, paint);
  }

  @override
  bool shouldRepaint(Square oldDelegate) {
    return type != oldDelegate.type;
  }
}
