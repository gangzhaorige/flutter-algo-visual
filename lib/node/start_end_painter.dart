import 'package:flutter/material.dart';

class StartPaintWidget extends StatefulWidget {
  const StartPaintWidget({
    Key? key,
    required this.unitSize,
  }) : super(key:key);

  final double unitSize;


  @override
  State<StartPaintWidget> createState() => _StartPaintWidgetState();
}

class _StartPaintWidgetState extends State<StartPaintWidget> with SingleTickerProviderStateMixin{
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

    animation = Tween<double>(begin: 0.0, end: 0.85).animate(CurvedAnimation(
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
      painter: StartPainter(
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

class StartPainter extends CustomPainter {
  StartPainter({
    required this.unitSize,
    required this.fraction,
  });

  final double unitSize;
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.green;
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
      text: 'S',
      style: TextStyle(
        color: Colors.green,
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
  bool shouldRepaint(StartPainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}

class EndPaintWidget extends StatefulWidget {
  const EndPaintWidget({
    Key? key,
    required this.unitSize,
  }) : super(key:key);

  final double unitSize;
  
  @override
  State<EndPaintWidget> createState() => _EndPaintWidgetState();
}

class _EndPaintWidgetState extends State<EndPaintWidget> with SingleTickerProviderStateMixin{
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
      painter: EndPainter(
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

class EndPainter extends CustomPainter {
  EndPainter({
    required this.unitSize,
    required this.fraction,
  });

  final double unitSize;
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.blue;
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
      text: 'D',
      style: TextStyle(
        color: Colors.blue,
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
  bool shouldRepaint(EndPainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}
