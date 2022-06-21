import 'package:flutter/material.dart';

class PathNodePainter extends CustomPainter {
  PathNodePainter({
    required this.unitSize,
    required this.fraction,
    required this.color,
  });

  final double unitSize;
  final double fraction;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    Rect rectl = Rect.fromCenter(
      center: Offset(unitSize / 2, unitSize / 2),
      width: fraction * (unitSize),
      height: fraction * (unitSize),
    );
    Paint paint = Paint();
    paint.color = color;
    canvas.drawRect(rectl, paint);
  }
  
  @override
  bool shouldRepaint(PathNodePainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}

class PathNodePaintWidget extends StatefulWidget {
  const PathNodePaintWidget({
    Key? key,
    required this.unitSize,
    required this.color,
  }) : super(key:key);

  final double unitSize;
  final Color color;

  @override
  State<PathNodePaintWidget> createState() => _PathNodePaintWidgetState();
}

class _PathNodePaintWidgetState extends State<PathNodePaintWidget> with SingleTickerProviderStateMixin{
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
      painter: PathNodePainter(
        unitSize: widget.unitSize,
        fraction: fraction, 
        color: widget.color,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}