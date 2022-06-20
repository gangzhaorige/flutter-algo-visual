import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:path_visualizer/main.dart';
import 'package:collection/collection.dart';
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
  biBfs,
  dijkstra,
  aStar,
}

class AlgoVisualizerTools extends ChangeNotifier {
  Brush curBrush = Brush.wall;
  double curSpeed = 10;
  bool isVisualizing = false;

  List<Algorithm> algos = <Algorithm>[
    Algorithm.bfs,
    Algorithm.dfs,
    Algorithm.biBfs,
    Algorithm.dijkstra,
    Algorithm.aStar,
  ];
  
  int selectedAlgorithm = 0;

  Algorithm getCurAlgorithm() {
    return algos[selectedAlgorithm];
  }

  void changeAlgorithm(int index) {
    selectedAlgorithm = index;
    notifyListeners();
  }

  void toggleVisualizing() {
    isVisualizing = !isVisualizing;
    notifyListeners();
  }

  void changeBrush() {
    if(curBrush == Brush.start) {
      curBrush = Brush.end;
    } else if (curBrush == Brush.end) {
      curBrush = Brush.wall;
    } else if(curBrush == Brush.wall){
      curBrush = Brush.weight;
    } else {
      curBrush = Brush.start;
    }
    notifyListeners();
  }

  void changeSpeed(double speed) {
    curSpeed = speed;
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

  List<NodeModel> bidirectional() {
    List<NodeModel> list = [];
    Queue<NodeModel> queue1 = Queue<NodeModel>();
    Queue<NodeModel> queue2 = Queue<NodeModel>();
    queue1.add(nodes[startRow][startCol]);
    nodes[startRow][startCol].visited = true;
    queue2.add(nodes[endRow][endCol]);
    nodes[endRow][endCol].visited2 = true;
    while(queue1.isNotEmpty && queue2.isNotEmpty) {
      NodeModel nodeFirst = queue1.removeFirst();
      NodeModel nodeSecond = queue2.removeFirst();
      if(nodeFirst.parent != null && nodeFirst.parent2 != null) {
        list.add(nodeFirst);
        return list;
      }
      list.add(nodeFirst);
      list.add(nodeSecond);
      for(List<int> direction in directions) {
        int dx = nodeFirst.row + direction[0];
        int dy = nodeFirst.col + direction[1];
        if(!isOutOfBound(dx, dy) && !nodes[dx][dy].visited && nodes[dx][dy].type != NodeType.wall) {
          nodes[dx][dy].visited = true;
          queue1.add(nodes[dx][dy]);
          nodes[dx][dy].parent = nodeFirst;
        }
      }
      for(List<int> direction in directions) {
        int dx = nodeSecond.row + direction[0];
        int dy = nodeSecond.col + direction[1];
        if(!isOutOfBound(dx, dy) && !nodes[dx][dy].visited2 && nodes[dx][dy].type != NodeType.wall) {
          nodes[dx][dy].visited2 = true;
          queue2.add(nodes[dx][dy]);
          nodes[dx][dy].parent2 = nodeSecond;
        }
      }
    }
    return list;
  }

  List<NodeModel> dfs() {
    List<NodeModel> list = [];
    dfsHelper(list, startRow, startCol);
    return list;
  }

  List<NodeModel> dijkstra() {
    List<NodeModel> list = [];
    PriorityQueue<NodeModel> queue = PriorityQueue<NodeModel>((NodeModel a, NodeModel b) => a.distance - b.distance);
    queue.add(nodes[startRow][startCol]);
    nodes[startRow][startCol].distance = 0;
    while(queue.isNotEmpty) {
      NodeModel curNode = queue.removeFirst();
      curNode.visited = true;
      list.add(curNode);
      if(curNode.row == endRow && curNode.col == endCol) {
        return list;
      }
      for(List<int> direction in directions) {
        int dx = curNode.row + direction[0];
        int dy = curNode.col + direction[1];
        if(isOutOfBound(dx, dy)) {
          continue;
        }
        if(nodes[dx][dy].type != NodeType.wall && !nodes[dx][dy].visited) {
          if(nodes[dx][dy].distance > curNode.distance + nodes[dx][dy].weight) {
            nodes[dx][dy].distance = curNode.distance + nodes[dx][dy].weight;
            nodes[dx][dy].parent = curNode;
            queue.add(nodes[dx][dy]);
          }
        }
      }
    }
    return list;
  }

  List<NodeModel> aStar() {
    List<NodeModel> list = <NodeModel>[];
    List<NodeModel> open = [];
    HashSet<NodeModel> closed = HashSet<NodeModel>();
    NodeModel start = nodes[startRow][startCol];
    start.hCost = calculateHeuristic(start);
    start.gCost = 0;
    start.distance = start.hCost + start.gCost;
    open.add(nodes[startRow][startCol]);
    while(open.isNotEmpty) {
      NodeModel curNode = getSmallest(open);
      closed.add(curNode);
      list.add(curNode);
      if(curNode.row == endRow && curNode.col == endCol) {
        return list;
      }
      for(List<int> direction in directions) {
        int dx = direction[0] + curNode.row;
        int dy = direction[1] + curNode.col;
        if(isOutOfBound(dx, dy) || nodes[dx][dy].type == NodeType.wall || closed.contains(nodes[dx][dy])) {
          continue;
        }
        NodeModel neighbor = nodes[dx][dy];
        int gCost = curNode.gCost + neighbor.weight;
        int hCost = calculateHeuristic(neighbor);
        int distance = gCost + hCost;
        if(neighbor.distance > distance || !open.contains(neighbor)) {
          neighbor.distance = distance;
          neighbor.gCost = gCost;
          neighbor.hCost = hCost;
          neighbor.parent = curNode;
          if(!open.contains(neighbor)) {
            open.add(neighbor);
          }
        }
      }
    }
    return list;
  }

  NodeModel getSmallest(List<NodeModel> list) {
    int index = 0;
    int distance = 10000000;
    int hCost = 10000000;
    for(int i = 0; i < list.length; i++) {
      NodeModel curNode = list[i];
      if(curNode.distance < distance) {
        index = i;
        distance = curNode.distance;
        hCost = curNode.hCost;
      } else if (curNode.distance == distance) {
        if(curNode.hCost < hCost) {
          index = i;
          hCost = curNode.hCost;
        }
      }
    }
    return list.removeAt(index);
  }

  int calculateHeuristic(NodeModel node) {
    NodeModel endNode = nodes[endRow][endCol];
    return ((node.row - endNode.row).abs() + (node.col - endNode.col).abs());
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

  List<NodeModel> getPathFromStartToEndBidirectional(List<NodeModel> nodes) {
    List<NodeModel> list = [];
    NodeModel cur = nodes[nodes.length - 1];
    if(cur.parent == null || cur.parent2 == null) {
      return list;
    }
    while(cur.parent != null) {
      list.add(cur);
      cur = cur.parent!;
    }
    cur = nodes[nodes.length - 1].parent2!;
    while(cur.parent2 != null) {
      list.insert(0, cur);
      cur = cur.parent2!;
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
      case Algorithm.biBfs:
        orderOfVisit = bidirectional();
        break;
      case Algorithm.dijkstra:
        orderOfVisit = dijkstra();
        break;
      case Algorithm.aStar:
        orderOfVisit = aStar();
        break;
    }
    return orderOfVisit;
  }

  Future<void> visualizeAlgorithm(Algorithm curAlgorithm, int speed, Function toggleVisualizing) async {
    toggleVisualizing();
    List<NodeModel> orderOfVisit = executeAlgorithm(curAlgorithm);
    List<NodeModel> pathingOrder;
    if(curAlgorithm == Algorithm.biBfs) {
      pathingOrder = getPathFromStartToEndBidirectional(orderOfVisit);
    } else {
      pathingOrder = getPathFromStartToEnd();
    }
    await visualizeVisitedNodes(orderOfVisit, speed).then((_) async {
      await visualizePath(pathingOrder, speed, orderOfVisit.length).then((_) async {
        await Future<dynamic>.delayed(Duration(milliseconds: orderOfVisit.length * speed + pathingOrder.length * speed + 500)).then((_) {
          toggleVisualizing();
        });
      });
    });
  }

  Future<void> visualizeVisitedNodes(List<NodeModel> orderOfVisit, int speed) async {
    for(int i = 0; i < orderOfVisit.length; i++) {
      Future<dynamic>.delayed(Duration(milliseconds: speed * i)).then((_) {
        if(!isStartOrEnd(orderOfVisit[i].row, orderOfVisit[i].col)) {
          grid.painter.renderVisitedNode(orderOfVisit[i].row, orderOfVisit[i].col, grid.unitSize);
        }
      });
    }
  }
  Future<void> visualizePath(List<NodeModel> pathingOrder, int speed, int delay) async {
    Future<dynamic>.delayed(Duration(milliseconds: speed * delay)).then((_) {
      int index = 0;
      for(int j = pathingOrder.length - 1; j >= 0; j--) {
        NodeModel cur = pathingOrder[j];
        Future<dynamic>.delayed(Duration(milliseconds: index * speed)).then((_) {
          if(!isStartOrEnd(cur.row, cur.col)) {
            grid.painter.renderPathNode(cur.row, cur.col, grid.unitSize);
          }
        });
        index++;
      }
    });
  }
}