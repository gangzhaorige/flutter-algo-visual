import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:path_visualizer/main.dart';
import 'package:collection/collection.dart';
import '../grid/grid.dart';
import '../node/node_model.dart';

const List<List<int>> eightDirections = <List<int>>[
  <int>[0, 1],
  <int>[1, 0],
  <int>[0, -1],
  <int>[-1, 0],
  <int>[-1, 1],
  <int>[1, -1],
  <int>[-1, -1],
  <int>[1, 1],
];

const List<List<int>> fourDirections = <List<int>>[
  <int>[0, 1],
  <int>[1, 0],
  <int>[0, -1],
  <int>[-1, 0],
];

enum Algorithm {
  dfs,
  bfs,
  biBfs,
  dijkstra,
  aStar,
}

class AlgoVisualizerTools extends ChangeNotifier {
  double _speed = 10;
  bool _isVisualizing = false;
  bool _isDiagonal = false;
  bool _isFirstTime = true;

  final List<Algorithm> _algos = <Algorithm>[
    Algorithm.bfs,
    Algorithm.dfs,
    Algorithm.biBfs,
    Algorithm.dijkstra,
    Algorithm.aStar,
  ];

  final List<Brush> _brushes = <Brush>[
    Brush.start,
    Brush.end,
    Brush.wall,
    Brush.weight,
    Brush.coin,
  ];

  int _selectedAlgorithm = 0;

  int _selectedBrush = 0;

  bool _hasCoin = false;

  int getSelectedBrush() {
    return _selectedBrush;
  }

  int getSelectedAlgorithm() {
    return _selectedAlgorithm;
  }

  List<Algorithm> getAlgos() {
    return _algos;
  }

  List<Brush> getBrushes() {
    return _brushes;
  }

  void toggleCoin() {
    _hasCoin = !_hasCoin;
    notifyListeners();
  }

  void setCoin(bool value) {
    _hasCoin = value;
    notifyListeners();
  }

  bool getCoin() {
    return _hasCoin;
  }

  Brush getCurBrush() {
    return _brushes[_selectedBrush];
  }

  bool getIsDiagonal() {
    return _isDiagonal;
  }

  void setDiagonal(bool value) {
    _isDiagonal = value;
    notifyListeners();
  }

  Algorithm getAlgorithm() {
    return _algos[_selectedAlgorithm];
  }

  void changeAlgorithm(int index) {
    _selectedAlgorithm = index;
    notifyListeners();
  }

  void toggleVisualizing() {
    _isVisualizing = !_isVisualizing;
    notifyListeners();
  }

  bool getVisualizing() {
    return _isVisualizing;
  }

  void changeBrush(int index) {
    _selectedBrush = index;
    notifyListeners();
  }

  double getSpeed() {
    return _speed;
  }

  void changeSpeed(double speed) {
    _speed = speed;
    notifyListeners();
  }

  void setFirstTime(bool condition) {
    _isFirstTime = condition;
  }

  bool getFirstTime() {
    return _isFirstTime;
  }
}

class Algorithms {

  final int startRow;
  final int startCol;
  final int endRow;
  final int endCol;
  final int coinRow;
  final int coinCol;
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
    required this.coinRow,
    required this.coinCol,
  });

  List<NodeModel> bfs(int startRow, int startCol, int endRow, int endCol, List<List<int>> directions) {
    List<NodeModel> list = <NodeModel>[];
    Queue<NodeModel> queue = Queue<NodeModel>();
    queue.add(nodes[startRow][startCol]);
    list.add(nodes[startRow][startCol]);
    nodes[startRow][startCol].visited = true;
    while(queue.isNotEmpty) {
      NodeModel currentNode = queue.removeFirst();
      list.add(currentNode);
      if(currentNode.row == endRow && currentNode.col == endCol) {
        return list;
      }
      List<NodeModel> neighbors = getNeighbors(currentNode.row, currentNode.col, directions);
      for(NodeModel neighbor in neighbors) {
        queue.add(neighbor);
        neighbor.parent = currentNode;
      }
    }
    return list;
  }

  List<NodeModel> bidirectionalBFS(int startRow, int startCol, int endRow, int endCol, List<List<int>> directions) {
    List<NodeModel> list = <NodeModel>[];
    Queue<NodeModel> queue1 = Queue<NodeModel>();
    Queue<NodeModel> queue2 = Queue<NodeModel>();
    queue1.add(nodes[startRow][startCol]);
    nodes[startRow][startCol].visited = true;
    queue2.add(nodes[endRow][endCol]);
    nodes[endRow][endCol].visited2 = true;
    while(queue1.isNotEmpty && queue2.isNotEmpty) {
      NodeModel nodeFirst = queue1.removeFirst();
      NodeModel nodeSecond = queue2.removeFirst();
      list.add(nodeFirst);
      list.add(nodeSecond);
      for(List<int> direction in directions) {
        int dx = nodeFirst.row + direction[0];
        int dy = nodeFirst.col + direction[1];
        if(!isOutOfBound(dx, dy) && !nodes[dx][dy].visited && nodes[dx][dy].type != NodeType.wall) {
          nodes[dx][dy].visited = true;
          queue1.add(nodes[dx][dy]);
          nodes[dx][dy].parent = nodeFirst;
          if(nodes[dx][dy].parent != null && nodes[dx][dy].parent2 != null) {
            list.add(nodes[dx][dy]);
            return list;
          }
        }
      }
      for(List<int> direction in directions) {
        int dx = nodeSecond.row + direction[0];
        int dy = nodeSecond.col + direction[1];
        if(!isOutOfBound(dx, dy) && !nodes[dx][dy].visited2 && nodes[dx][dy].type != NodeType.wall) {
          nodes[dx][dy].visited2 = true;
          queue2.add(nodes[dx][dy]);
          nodes[dx][dy].parent2 = nodeSecond;
          if(nodes[dx][dy].parent != null && nodes[dx][dy].parent2 != null) {
            list.add(nodes[dx][dy]);
            return list;
          }
        }
      }
    }
    return list;
  }

  List<NodeModel> dfs(int startRow, int startCol, int endRow, int endCol, List<List<int>> directions) {
    List<NodeModel> list = <NodeModel>[];
    dfsHelper(list, startRow, startCol, endRow, endCol, directions);
    return list;
  }

  List<NodeModel> dijkstra(int startRow, int startCol, int endRow, int endCol, List<List<int>> directions) {
    List<NodeModel> list = <NodeModel>[];
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
          int weight = ((isMovingDiagonal(direction[0], direction[1]) ? nodes[dx][dy].weight * 1.5 : nodes[dx][dy].weight) * 10).round();
          if(nodes[dx][dy].distance > curNode.distance + weight) {
            nodes[dx][dy].distance = curNode.distance + weight;
            nodes[dx][dy].parent = curNode;
            queue.add(nodes[dx][dy]);
          }
        }
      }
    }
    return list;
  }

  List<NodeModel> aStar(int startRow, int startCol, int endRow, int endCol, List<List<int>> directions, bool isEightDirection) {
    List<NodeModel> list = <NodeModel>[];
    List<NodeModel> open = <NodeModel>[];
    HashSet<NodeModel> closed = HashSet<NodeModel>();
    NodeModel start = nodes[startRow][startCol];
    start.hCost = getDistance(start, nodes[endRow][endCol], 1, isEightDirection);
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
        int gCost = curNode.gCost;
        int hCost = getDistance(curNode, neighbor, neighbor.weight, isEightDirection);
        int distance = gCost + hCost;
        if(distance < neighbor.gCost || !open.contains(neighbor)) {
          neighbor.gCost = distance;
          neighbor.hCost = getDistance(neighbor, nodes[endRow][endCol], 1, isEightDirection);
          neighbor.parent = curNode;
          if(!open.contains(neighbor)) {
            open.add(neighbor);
          }
        }
      }
    }
    return list;
  }

  int getDistance(NodeModel a, NodeModel b, int weight, bool isEightDirection) {
    if(!isEightDirection) {
      return ((a.row - b.row).abs() + (a.col - b.col).abs()) * weight;
    }
    int normal = weight * 10;
    int diagonal = (weight * 1.4 * 10).round();
    int dstX = (a.row - b.row).abs();
		int dstY = (a.col - b.col).abs();
		if (dstX > dstY) {
      return diagonal * dstY + normal * (dstX - dstY);
    }
		return diagonal * dstX + normal * (dstY - dstX);
  }

  bool isMovingDiagonal(int a, int b) {
    return a.abs() + b.abs() == 2;
  }

  NodeModel getSmallest(List<NodeModel> list) {
    int index = 0;
    int hCost = 10000000;
    int fn = 10000000;
    for(int i = 0; i < list.length; i++) {
      if(list[i].getFn() < fn) {
        hCost = list[i].hCost;
        fn = list[i].getFn();
        index = i;
      } else if (list[i].getFn() == fn) {
        if(list[i].hCost < hCost) {
          hCost = list[i].hCost;
          index = i;
        }
      }
    }
    return list.removeAt(index);
  }


  void dfsHelper(List<NodeModel> list, int row, int col, int endRow, int endCol, List<List<int>> directions) {
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
        dfsHelper(list, dx, dy, endRow, endCol, directions);
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

  bool isCoin(int row, int col) {
    if(row == coinRow && col == coinCol) {
      return true;
    }
    return false;
  }

  List<NodeModel> getNeighbors(int row, int col, List<List<int>> directions) {
    List<NodeModel> neighbors = <NodeModel>[];
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

  List<NodeModel> getPathFromStartToEnd(int endRow, int endCol, bool hasCoin) {
    List<NodeModel> list = <NodeModel>[];
    NodeModel cur = nodes[endRow][endCol];
    while(cur.parent != null) {
      list.add(cur);
      cur = cur.parent!;
    }
    if(hasCoin) {
      list.add(nodes[startRow][startCol]);
    }
    return list;
  }

  List<NodeModel> getPathFromStartToEndBidirectional(List<NodeModel> nodes, bool hasCoin) {
    List<NodeModel> list = <NodeModel>[];
    NodeModel cur = nodes[nodes.length - 1];
    if(cur.parent == null || cur.parent2 == null) {
      return list;
    }
    if(hasCoin) {
      list.add(this.nodes[coinRow][coinCol]);
    } else {
      list.add(this.nodes[endRow][endCol]);
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
    list.add(this.nodes[startRow][startCol]);
    return list;
  }

  List<NodeModel> executeAlgorithm(Algorithm curAlgorithm, int startRow, int startCol, int endRow, int endCol, bool hasDiagonal) {
    List<List<int>> directions = hasDiagonal ? eightDirections : fourDirections;

    List<NodeModel> orderOfVisit;
    switch(curAlgorithm) {
      case Algorithm.dfs:
        orderOfVisit = dfs(startRow, startCol, endRow, endCol, directions);
        break;
      case Algorithm.bfs:
        orderOfVisit = bfs(startRow, startCol, endRow, endCol, directions);
        break;
      case Algorithm.biBfs:
        orderOfVisit = bidirectionalBFS(startRow, startCol, endRow, endCol, directions);
        break;
      case Algorithm.dijkstra:
        orderOfVisit = dijkstra(startRow, startCol, endRow, endCol, directions);
        break;
      case Algorithm.aStar:
        orderOfVisit = aStar(startRow, startCol, endRow, endCol, directions, hasDiagonal);
        break;
    }
    return orderOfVisit;
  }

  Future<void> visualizeAlgorithm(Algorithm curAlgorithm, int speed, Function toggleVisualizing, bool hasCoin, bool hasDiagonal) async {
    toggleVisualizing();
    int endRow = this.endRow;
    int endCol = this.endCol;
    if(hasCoin) {
      endRow = coinRow;
      endCol = coinCol;
    }
    List<NodeModel> orderOfVisit = executeAlgorithm(curAlgorithm, startRow, startCol, endRow, endCol, hasDiagonal);
    List<NodeModel> pathingOrder = curAlgorithm == Algorithm.biBfs ? getPathFromStartToEndBidirectional(orderOfVisit, hasCoin) : getPathFromStartToEnd(endRow, endCol, true);
    await visualizeVisitedNodes(orderOfVisit, speed, Colors.blueGrey, hasCoin).then((_) async {
      if(hasPathFromStartToDest(orderOfVisit, startRow, startCol, endRow, endCol, curAlgorithm)) {
        await visualizePath(pathingOrder, speed, orderOfVisit.length, Colors.yellowAccent, hasCoin).then((_) async {
          await Future<dynamic>.delayed(Duration(milliseconds: orderOfVisit.length * speed + pathingOrder.length * speed)).then((_) async {
            if(!hasCoin) {
              toggleVisualizing();
            } else {
              grid.resetPath(false);
              orderOfVisit = executeAlgorithm(curAlgorithm, coinRow, coinCol, this.endRow, this.endCol, hasDiagonal);
              pathingOrder = curAlgorithm == Algorithm.biBfs ? getPathFromStartToEndBidirectional(orderOfVisit, false) : getPathFromStartToEnd(this.endRow, this.endCol, false);
              await visualizeVisitedNodes(orderOfVisit, speed, Colors.redAccent, hasCoin).then((_) async {
                await visualizePath(pathingOrder, speed, orderOfVisit.length, Colors.yellowAccent, hasCoin).then((_) async {
                  await Future<dynamic>.delayed(Duration(milliseconds: orderOfVisit.length * speed + pathingOrder.length * speed + 500)).then((_) async {
                    toggleVisualizing();
                  });
                });
              });
            }
          });
        });
      } else {
        await Future<dynamic>.delayed(Duration(milliseconds: orderOfVisit.length * speed + 500)).then((_) async {
          toggleVisualizing();
        });
      }
    });
  }

  bool hasPathFromStartToDest(List<NodeModel> orderOfVisit, int sourceRow, int sourceCol, int destRow, int destCol, Algorithm algo) {
    if(algo == Algorithm.biBfs) {
      return orderOfVisit[orderOfVisit.length - 1].visited && orderOfVisit[orderOfVisit.length - 1].visited2;
    }
    NodeModel source = orderOfVisit[0];
    NodeModel dest = orderOfVisit[orderOfVisit.length - 1];
    return dest.row == destRow && dest.col == destCol && source.row == sourceRow && source.col == sourceCol;
  }

  Future<void> visualizeVisitedNodes(List<NodeModel> orderOfVisit, int speed, Color color, bool hasCoin) async {
    for(int i = 0; i < orderOfVisit.length; i++) {
      int row = orderOfVisit[i].row;
      int col = orderOfVisit[i].col;
      Future<dynamic>.delayed(Duration(milliseconds: speed * i)).then((_) {
        grid.painter.renderVisitedNode(row, col, grid.unitSize, color);
      });
    }
  }
  Future<void> visualizePath(List<NodeModel> pathingOrder, int speed, int delay, Color color, bool hasCoin) async {
    Future<dynamic>.delayed(Duration(milliseconds: speed * delay)).then((_) {
      int index = 0;
      for(int j = pathingOrder.length - 1; j >= 0; j--) {
        NodeModel cur = pathingOrder[j];
        Future<dynamic>.delayed(Duration(milliseconds: index * speed)).then((_) {
          grid.painter.renderPathNode(cur.row, cur.col, grid.unitSize, color);
        });
        index++;
      }
    });
  }
}