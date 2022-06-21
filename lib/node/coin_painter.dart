import 'package:flutter/material.dart';

class CoinPaintWidget extends StatefulWidget {
  const CoinPaintWidget({
    Key? key,
    required this.unitSize,
  }) : super(key:key);

  final double unitSize;
  
  @override
  State<CoinPaintWidget> createState() => _CoinPaintWidgetState();
}

class _CoinPaintWidgetState extends State<CoinPaintWidget> with SingleTickerProviderStateMixin{
  double fraction = 0;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    animation = Tween<double>(begin: 0.5, end: 0.85).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    ))
    ..addListener((){
      setState(() {
        fraction = animation.value;
      });
    });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CoinPainter(
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

class CoinPainter extends CustomPainter {
  CoinPainter({
    required this.unitSize,
    required this.fraction,
  });

  final double unitSize;
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.orange;
    paint.strokeWidth = 2;
    canvas.drawCircle(
      Offset(
        unitSize / 2,
        unitSize / 2,
      ),
      unitSize / 2 * fraction,
      paint,
    );
    const TextSpan textSpan = TextSpan(
      text: 'C',
      style: TextStyle(
        color: Colors.orange,
        fontSize: 12
      )
    );
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (unitSize - textPainter.width) / 2,
        (unitSize - textPainter.height) / 2,
      ),
    );
  }
  
  @override
  bool shouldRepaint(CoinPainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}
