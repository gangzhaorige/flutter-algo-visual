import 'package:flutter/material.dart';

import '../main.dart';
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
  NodeType.visiting: Colors.orangeAccent,
  NodeType.pathing: Colors.yellow,
  NodeType.weight: Colors.blue,
};

const Map<Brush, Color> brushColor = {
  Brush.wall: Colors.black,
  Brush.start: Colors.greenAccent,
  Brush.end: Colors.red,
};

class NodeModel extends ChangeNotifier {
  NodeModel({
    Key? key,
    required this.row,
    required this.col,
    this.visited = false,
    this.visited2 = false,
    required this.type,
  });

  int row;
  int col;
  bool visited;
  bool visited2;
  NodeType type;
  NodeModel? parent;
  NodeModel? parent2;

  void changeNodeType(NodeType type) {
    this.type = type;
    notifyListeners();
  }

  @override
  String toString() {
    return '$row $col';
  }
}

class Painter extends ChangeNotifier {
  Map<String, Widget> map = {};
      
  void removeWall(int row, int column) {
    map.remove('$row $column');
    notifyListeners();
  }

  void addNodeWidget(int row, int column, double unitSize, Function(int i, int j, NodeType type) addNode, NodeType type) {
    map['$row $column'] = Positioned(
      key: UniqueKey(),
      left: row * (unitSize.toDouble()),
      top: column * (unitSize.toDouble()),
      child: RepaintBoundary(
        child: NodePaintWidget(
          type: type,
          unitSize: unitSize,
          row: row,
          column: column,
          callback: (int row, int column, NodeType type) {
            removeWall(row, column);
            addNode(row, column, type);
          },
        ),
      )
    );
    notifyListeners();
  }
}
