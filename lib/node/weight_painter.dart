
import 'package:flutter/material.dart';

class WeightPainter extends CustomPainter {
  WeightPainter({
    required this.unitSize,
    required this.fraction,
  });

  final double unitSize;
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.purple;
    paint.strokeWidth = 2;
    canvas.drawCircle(
      Offset(
        unitSize / 2,
        unitSize / 2,
      ),
      unitSize / 2 * fraction,
      paint,
    );
    canvas.drawLine(
      Offset(
        unitSize / 4,
        unitSize / 4,
      ),
      Offset(
        unitSize - unitSize / 4,
        unitSize - unitSize / 4,
      ),
      paint,
    );
    canvas.drawLine(
      Offset(
        unitSize - unitSize / 4,
        unitSize / 4,
      ),
      Offset(
        unitSize / 4,
        unitSize - unitSize / 4,
      ), 
      paint,
    );
  }
  @override
  bool shouldRepaint(WeightPainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}

class WeightPaintWidget extends StatefulWidget {
  const WeightPaintWidget({
    Key? key,
    required this.unitSize,
  }) : super(key:key);

  final double unitSize;

  @override
  State<WeightPaintWidget> createState() => _WeightPaintWidgetState();
}

class _WeightPaintWidgetState extends State<WeightPaintWidget> with SingleTickerProviderStateMixin{
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
    );

    animation = Tween<double>(begin: 0.0, end: 0.85).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
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
      painter: WeightPainter(
        unitSize: widget.unitSize,
        fraction: fraction, 
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}