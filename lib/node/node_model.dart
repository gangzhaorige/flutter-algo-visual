import 'package:flutter/material.dart';

import '../main.dart';

enum NodeType {
  empty,
  wall,
  start,
  end,
  weight,
  visiting,
  pathing,
}

const Map<Brush, Color> brushColor = {
  Brush.wall: Colors.black,
  Brush.start: Colors.greenAccent,
  Brush.end: Colors.orange,
  Brush.weight: Colors.purple,
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
  });

  int row;
  int col;
  int weight;
  int distance;
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