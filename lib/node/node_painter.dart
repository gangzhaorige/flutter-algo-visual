
import 'package:flutter/material.dart';

import 'node_model.dart';

class NodePainter extends CustomPainter {
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
    paint.color = Colors.pink;
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

class WeightPaintWidget extends StatefulWidget {
  const WeightPaintWidget({
    Key? key,
    required this.unitSize,
    required this.row,
    required this.column,
  }) : super(key:key);

  final double unitSize;
  final int row;
  final int column;

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

class StartPaintWidget extends StatefulWidget {
  const StartPaintWidget({
    Key? key,
    required this.unitSize,
    required this.row,
    required this.column,
  }) : super(key:key);

  final double unitSize;
  final int row;
  final int column;

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
    textPainter.layout(
      minWidth: unitSize,
      maxWidth: unitSize
    );
    textPainter.paint(canvas, Offset(
      unitSize / 2 - unitSize / 7,
      unitSize / 4.5,
    ),);
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
    required this.row,
    required this.column,
  }) : super(key:key);

  final double unitSize;
  final int row;
  final int column;

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
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        print('im here');
        controller.reverse();
      }
    });
    
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
      text: 'D',
      style: TextStyle(
        color: Colors.orange,
        fontSize: 12
      )
    );
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: unitSize,
      maxWidth: unitSize
    );
    textPainter.paint(canvas, Offset(
      unitSize / 2 - unitSize / 7,
      unitSize / 4.5,
    ),);
  }
  
  @override
  bool shouldRepaint(EndPainter oldDelegate) {
    if(fraction != oldDelegate.fraction) {
      return true;
    }
    return false;
  }
}