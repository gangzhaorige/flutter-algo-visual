import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  const GridPainter(this.rows, this.columns, this.unitSize, this.width, this.height);
  final int rows;
  final int columns;
  final double unitSize;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    Rect background = Rect.fromLTRB(0, 0, size.width, size.height);
    paint.color = Colors.white10;
    canvas.drawRect(background, paint);

    paint.color = Colors.blue;
    paint.strokeWidth = 1;
    
    for (int i = 0; i < rows + 1; i++) {
      canvas.drawLine(
        Offset(i.toDouble() * (unitSize), 0),
        Offset(i.toDouble() * (unitSize), height),
        paint,
      );
    }

    for (int i = 0; i < columns + 1; i++) {
      canvas.drawLine(
        Offset(0, i.toDouble() * (unitSize)),
        Offset(width, i.toDouble() * (unitSize)),
        paint,
      );
    }
  }
  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}