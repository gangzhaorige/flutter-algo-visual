import 'package:flutter/material.dart';

class WallPainter extends CustomPainter {
  WallPainter({
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
    canvas.drawRect(rectl, paint);
  }
  
  @override
  bool shouldRepaint(WallPainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}

class WallPaintWidget extends StatefulWidget {
  const WallPaintWidget({
    Key? key,
    required this.unitSize,
  }) : super(key:key);

  final double unitSize;

  @override
  State<WallPaintWidget> createState() => _WallPaintWidgetState();
}

class _WallPaintWidgetState extends State<WallPaintWidget> with SingleTickerProviderStateMixin{
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
      painter: WallPainter(
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