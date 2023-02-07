import 'package:flutter/material.dart';
import 'package:path_visualizer/algorithm/algorithm.dart';

enum NodeType {
  empty,
  wall,
  start,
  end,
  weight,
  visiting,
  pathing,
  coin,
}

final Map<Brush, Color> brushColor = <Brush,Color>{
  Brush.wall: Colors.black,
  Brush.start: Colors.greenAccent,
  Brush.end: Colors.orange,
  Brush.weight: Colors.pink,
};

class NodeModel extends ChangeNotifier {
  NodeModel({
    Key? key,
    required this.row,
    required this.col,
    this.visited = false,
    this.visited2 = false,
    required this.type,
    this.weight = 1,
    this.distance = 10000,
    this.gCost = 0,
    this.hCost = 0,
  });

  int row;
  int col;
  int weight;
  int distance;
  bool visited;
  bool visited2;
  NodeType type;
  int gCost;
  int hCost;
  NodeModel? parent;
  NodeModel? parent2;

  int getFn() {
    return gCost + hCost;
  }

  void changeNodeType(NodeType type) {
    this.type = type;
    notifyListeners();
  }

  @override
  String toString() {
    return '$row $col';
  }

  @override
  int get hashCode => Object.hash(row, col);
  
  @override
  bool operator ==(Object other) {
    return other is NodeModel && row == other.row && col == other.col;
  }
}