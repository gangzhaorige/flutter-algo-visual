import 'package:flutter/material.dart';

import 'node_painter.dart';

enum NodeType {
  empty,
  wall,
  start,
  end,
  weight,
  visiting,
  pathing,
}

const Map<NodeType, Color> nodeColor = {
  NodeType.empty: Colors.white,
  NodeType.wall: Colors.black,
  NodeType.end: Colors.red,
  NodeType.start: Colors.green,
  NodeType.visiting: Colors.blueGrey,
  NodeType.pathing: Colors.yellow,
};

class NodeModel extends ChangeNotifier {
  NodeModel({
    Key? key,
    required this.row,
    required this.col,
    this.visited = false,
    required this.type,
  });

  int row;
  int col;
  bool visited;
  NodeType type;
  NodeModel? parent;

  void changeNodeType(NodeType type) {
    this.type = type;
    notifyListeners();
  }
}

class Painter extends ChangeNotifier {
  Map<String, Widget> map = {};
      
  void removeWall(int row, int column) {
    map.remove('$row $column');
    notifyListeners();
  }

  void addWall(int row, int column, double unitSize, Function(int i, int j) addWall) {
    map['$row $column'] = Positioned(
      key: UniqueKey(),
      left: row * (unitSize.toDouble()),
      top: column * (unitSize.toDouble()),
      child: RepaintBoundary(
        child: WallNodePaintWidget(
          type: NodeType.wall,
          unitSize: unitSize,
          row: row,
          column: column,
          callback: (int row, int column, NodeType type) {
            removeWall(row, column);
            addWall(row, column);
          },
        ),
      )
    );
    notifyListeners();
  }
}
