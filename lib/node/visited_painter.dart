import 'package:flutter/material.dart';

class VisitedNodePainter extends CustomPainter {
  VisitedNodePainter({
    required this.unitSize,
    required this.fraction,
  });

  final double unitSize;
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rectl = Rect.fromCenter(
      center: Offset(unitSize / 2, unitSize / 2),
      width: fraction * (unitSize),
      height: fraction * (unitSize),
    );
    Paint paint = Paint();
    paint.color = Colors.orange;
    canvas.drawRect(rectl, paint);
  }
  
  @override
  bool shouldRepaint(VisitedNodePainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}

class VisitedNodePaintWidget extends StatefulWidget {
  const VisitedNodePaintWidget({
    Key? key,
    required this.unitSize,
  }) : super(key:key);

  final double unitSize;

  @override
  State<VisitedNodePaintWidget> createState() => _VisitedNodePaintWidgetState();
}

class _VisitedNodePaintWidgetState extends State<VisitedNodePaintWidget> with SingleTickerProviderStateMixin{
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

    animation = Tween<double>(begin: 0.0, end: 0.95).animate(CurvedAnimation(
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
      painter: VisitedNodePainter(
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
