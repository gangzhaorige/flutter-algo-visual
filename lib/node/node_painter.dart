
import 'package:flutter/material.dart';

import 'node_model.dart';

class NodePainter extends CustomPainter{
  NodePainter({
    required this.unitSize,
    required this.fraction,
    required this.type,
  });

  final double unitSize;
  final double fraction;
  final NodeType type;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rectl = Rect.fromCenter(
      center: Offset(unitSize / 2, unitSize / 2),
      width: fraction * (unitSize),
      height: fraction * (unitSize),
    );
    Paint paint = Paint();
    paint.color = nodeColor[type] as Color;
    canvas.drawRect(rectl, paint);
  }
  
  @override
  bool shouldRepaint(NodePainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}

class NodePaintWidget extends StatefulWidget {
  const NodePaintWidget({
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
  State<NodePaintWidget> createState() => _NodePaintWidgetState();
}

class _NodePaintWidgetState extends State<NodePaintWidget> with SingleTickerProviderStateMixin{
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

    animation = Tween<double>(begin: 0.0, end: 0.96).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutSine,
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
      painter: NodePainter(
        unitSize: widget.unitSize,
        fraction: fraction, 
        type: widget.type,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
      painter: Square(
        type: type,
        row: row,
        col: col,
        unitSize: unitSize,
      ),
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
      width: unitSize,
      height: unitSize,
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
