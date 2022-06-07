import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:path_visualizer/main.dart';

import '../grid/grid.dart';
import '../node/node_model.dart';

const List<List<int>> directions = <List<int>>[
  <int>[0, 1],  // down
  <int>[1, 0],  // right
  <int>[0, -1], // up
  <int>[-1, 0], // left
];

enum Algorithm {
  dfs,
  bfs,
}

class AlgoVisualizerTools extends ChangeNotifier {
  Brush curBrush = Brush.wall;
  double curSpeed = 15;
  Algorithm curAlgorithm = Algorithm.bfs;
  bool isVisualizing = false;

  void toggleVisualizing() {
    isVisualizing = !isVisualizing;;
    notifyListeners();
  }

  void changeBrush() {
    if(curBrush == Brush.start) {
      curBrush = Brush.end;
    } else if (curBrush == Brush.end) {
      curBrush = Brush.wall;
    } else {
      curBrush = Brush.start;
    }
    notifyListeners();
  }

  void changeSpeed(double speed) {
    curSpeed = speed;
    notifyListeners();
  }

  void changeAlgorithm(Algorithm algorithm) {
    curAlgorithm = algorithm;
    notifyListeners();
  }
}

class Algorithms {

  final int startRow;
  final int startCol;
  final int endRow;
  final int endCol;
  final int rows;
  final int columns;
  List<List<NodeModel>> nodes;
  final Grid grid;

  Algorithms({
    required this.startRow,
    required this.startCol,
    required this.endRow,
    required this.endCol,
    required this.rows, 
    required this.columns,
    required this.nodes,
    required this.grid,
  });

  List<NodeModel> bfs() {
    List<NodeModel> list = [];
    Queue<NodeModel> queue = Queue<NodeModel>();
    queue.add(nodes[startRow][startCol]);
    nodes[startRow][startCol].visited = true;
    while(queue.isNotEmpty) {
      NodeModel currentNode = queue.removeFirst();
      list.add(currentNode);
      if(currentNode.row == endRow && currentNode.col == endCol) {
        return list;
      }
      List<NodeModel> neighbors = getNeighbors(currentNode.row, currentNode.col);
      for(NodeModel neighbor in neighbors) {
        queue.add(neighbor);
        neighbor.parent = currentNode;
      }
    }
    return list;
  }

  List<NodeModel> dfs() {
    List<NodeModel> list = [];
    dfsHelper(list, startRow, startCol);
    return list;
  }

  void dfsHelper(List<NodeModel> list, int row, int col) {
    NodeModel curNode = nodes[row][col];
    if(curNode.visited || nodes[endRow][endCol].visited) {
      return;
    }
    curNode.visited = true;
    list.add(curNode);
    if(curNode.row == endRow && curNode.col == endCol) {
      return;
    }
    for(List<int> direction in directions) {
      int dx = row + direction[0];
      int dy = col + direction[1];
      if(!isOutOfBound(dx, dy) && nodes[dx][dy].type != NodeType.wall && !nodes[dx][dy].visited) {
        nodes[dx][dy].parent = curNode;
        dfsHelper(list, dx, dy);
      }
    }
  }

  bool isOutOfBound(int row, int col) {
    if(row < 0 || row >= rows || col < 0 || col >= columns) {
      return  true;
    }
    return false;
  }


  bool isStartOrEnd(int row, int col) {
    if(row == startRow && col == startCol || row == endRow && col == endCol) {
      return true;
    }
    return false;
  }

  List<NodeModel> getNeighbors(int row, int col) {
    List<NodeModel> neighbors = [];
    for(List<int> direction in directions) {
      int dx = row + direction[0];
      int dy = col + direction[1];
      if(!isOutOfBound(dx, dy) && nodes[dx][dy].type != NodeType.wall && !nodes[dx][dy].visited) {
        nodes[dx][dy].visited = true;
        neighbors.add(nodes[dx][dy]);
      }
    }
    return neighbors;
  }

  List<NodeModel> getPathFromStartToEnd() {
    List<NodeModel> list = [];
    NodeModel cur = nodes[endRow][endCol];
    while(cur.parent != null) {
      list.add(cur);
      cur = cur.parent!;
    }
    return list;
  }

  List<NodeModel> executeAlgorithm(Algorithm curAlgorithm) {
    List<NodeModel> orderOfVisit;
    switch(curAlgorithm) {
      case Algorithm.dfs:
        orderOfVisit = dfs();
        break;
      case Algorithm.bfs:
        orderOfVisit = bfs();
        break;
    }
    return orderOfVisit;
  }

  Future<void> visualizeAlgorithm(Algorithm curAlgorithm, int speed, Function toggleVisualizing) {
    toggleVisualizing();
    List<NodeModel> orderOfVisit = executeAlgorithm(curAlgorithm);
    List<NodeModel> pathingOrder = getPathFromStartToEnd();
    for(int i = 0; i <= orderOfVisit.length; i++) {
      if(i == orderOfVisit.length) {
        Future<dynamic>.delayed(Duration(milliseconds: speed * i)).then((_) {
          int index = 0;
          for(int j = pathingOrder.length - 1; j >= 0; j--) {
            NodeModel cur = pathingOrder[j];
            Future<dynamic>.delayed(Duration(milliseconds: index * speed)).then((_) {
              if(!isStartOrEnd(cur.row, cur.col)) {
                grid.walls.addNodeWidget(cur.row, cur.col, grid.unitSize, (int i, int j, NodeType k) => grid.createNode(i, j, k), NodeType.pathing);
              }
            });
            index++;
          }
        });
        Future<dynamic>.delayed(Duration(milliseconds: orderOfVisit.length * speed + pathingOrder.length * speed)).then((value) {
          toggleVisualizing();
        });
        return Future<dynamic>.value(orderOfVisit.length * speed + pathingOrder.length * speed);
      }
      Future<dynamic>.delayed(Duration(milliseconds: speed * i)).then((_) {
        if(!isStartOrEnd(orderOfVisit[i].row, orderOfVisit[i].col)) {
          grid.walls.addNodeWidget(orderOfVisit[i].row, orderOfVisit[i].col, grid.unitSize, (int i, int j, NodeType k) => grid.createNode(i, j, k), NodeType.visiting);
        }
      });
    }
    return Future<dynamic>.value(orderOfVisit.length * speed + pathingOrder.length * speed);
  }
}