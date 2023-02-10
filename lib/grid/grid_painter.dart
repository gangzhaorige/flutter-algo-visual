import 'package:flutter/material.dart';

import '../node/coin_painter.dart';
import '../node/path_painter.dart';
import '../node/start_end_painter.dart';
import '../node/visited_painter.dart';
import '../node/wall_painter.dart';
import '../node/weight_painter.dart';

class GridPainter extends CustomPainter {
  const GridPainter(this.rows, this.columns, this.unitSize, this.width, this.height, this.color, this.backgroudColor);
  final int rows;
  final int columns;
  final double unitSize;
  final double width;
  final double height;
  final Color color;
  final Color backgroudColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    Rect background = Rect.fromLTRB(0, 0, size.width, size.height);
    paint.color = backgroudColor;
    canvas.drawRect(background, paint);

    paint.color = color;
    paint.strokeWidth = 0.7;
    
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

class NodeLocation extends StatelessWidget {
  const NodeLocation(
    Key? key,
    this.row,
    this.col,
    this.unitSize,
    this.child,
  ) : super(key: key);

  final int row;
  final int col;
  final double unitSize;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      key: key,
      left: row * (unitSize.toDouble()),
      top: col * (unitSize.toDouble()),
      child: RepaintBoundary(
        child: child,
      ),
    );
  }

}

class Painter extends ChangeNotifier {

  late List<List<Widget?>> nodePainter;
  Map<String, Widget> visitedNodePainter = <String, Widget>{};
  Map<String, Widget> pathNodePainter = <String, Widget>{};
  Widget? coinPainter;
  final double unitSize;

  Painter(int startRow, int startCol, int endRow, int endCol, int rows, int columns, this.unitSize, int coinRow, int coinCol) {
    nodePainter = List<List<Widget?>>.generate(rows, (int row) => List<Widget?>.generate(columns, (int col) => null));
    nodePainter[startRow][startCol] = NodeLocation(UniqueKey(), startRow, startCol, unitSize, StartPaintWidget(unitSize: unitSize));
    nodePainter[endRow][endCol] = NodeLocation(UniqueKey(), endRow, endCol, unitSize, EndPaintWidget(unitSize: unitSize));
    coinPainter = NodeLocation(UniqueKey(), coinRow, coinCol, unitSize, CoinPaintWidget(unitSize: unitSize));
  }

  void changeToStartWidget(int row, int col, int prevRow, int prevCol) {
    nodePainter[prevRow][prevCol] = null;
    nodePainter[row][col] = NodeLocation(UniqueKey(), row, col, unitSize, StartPaintWidget(unitSize: unitSize));
    notifyListeners();
  }

  void changeToEndWidget(int row, int col, int prevRow, int prevCol) {
    nodePainter[prevRow][prevCol] = null;
    nodePainter[row][col] = NodeLocation(UniqueKey(), row, col, unitSize, EndPaintWidget(unitSize: unitSize));
    notifyListeners();
  }

  void changeToCoinWidget(int row, int col, int prevRow, int prevCol) {
    coinPainter = NodeLocation(UniqueKey(), row, col, unitSize, CoinPaintWidget(unitSize: unitSize));
    notifyListeners();
  }

  void changeToWallWidget(int row, int col) {
    nodePainter[row][col] = NodeLocation(UniqueKey(), row, col, unitSize, WallPaintWidget(unitSize: unitSize));
    notifyListeners();
  }

  void changeToWeightWidget(int row, int col) {
    nodePainter[row][col] = NodeLocation(UniqueKey(), row, col, unitSize, WeightPaintWidget(unitSize: unitSize));
    notifyListeners();
  }

  void removeWidget(int row, int col) {
    nodePainter[row][col] = null;
    notifyListeners();
  }

  void renderVisitedNode(int row, int column, double unitSize, Color color) {
    visitedNodePainter['$row $column'] = Positioned(
      key: UniqueKey(),
      left: row * (unitSize.toDouble()),
      top: column * (unitSize.toDouble()),
      child: RepaintBoundary(
        child: VisitedNodePaintWidget(
          unitSize: unitSize,
          color: color,
        ),
      )
    );
    notifyListeners();
  }

  void renderPathNode(int row, int column, double unitSize, Color color) {
    pathNodePainter['$row $column'] = Positioned(
      key: UniqueKey(),
      left: row * (unitSize.toDouble()),
      top: column * (unitSize.toDouble()),
      child: RepaintBoundary(
        child: PathNodePaintWidget(
          unitSize: unitSize,
          color: color,
        ),
      )
    );
    notifyListeners();
  }

  void removePathAndVisited() {
    visitedNodePainter = <String, Widget>{};
    pathNodePainter = <String, Widget>{};
    notifyListeners();
  }
}
