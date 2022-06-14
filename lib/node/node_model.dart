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

class NodeModel extends ChangeNotifier implements Comparable {
  NodeModel({
    Key? key,
    required this.row,
    required this.col,
    this.visited = false,
    this.visited2 = false,
    required this.type,
    this.weight = 1,
    this.distance = 10000,
    this.fCost = 0,
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
  int fCost;
  int gCost;
  int hCost;
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

  @override
  int get hashCode => Object.hash(row, col);
  
  @override
  bool operator ==(Object other) {
    return other is NodeModel && row == other.row && col == other.col;
  }
  
  @override
  int compareTo(other) {
    if(fCost > other.fCost) {
      return 1;
    } else if(fCost < other.fCost) {
      return -1;
    } else {
      if(hCost < other.hCost) {
        return - 1;
      } else if(hCost > other.hCost){
        return 1;
      } else {
        return other.gCost - gCost;
      }
    }
  }
 
}