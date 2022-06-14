import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../node/node_model.dart';
import '../algorithm/algorithm.dart';
import 'grid_gesture.dart';
import 'grid_painter.dart';

class GridWidget extends StatelessWidget {

  final Grid grid;

  const GridWidget({
    Key? key,
    required this.grid,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    print('Rebuilding Grid Widget');
    return FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(
        width: grid.width,
        height: grid.height,
        child: GridGestureDetector(
          width: grid.width,
          unitSize: grid.unitSize,
          rows: grid.rows,
          columns: grid.columns,
          height: grid.height,
          onDragNode: (int i, int j, int newI, int newJ) {
            if(Provider.of<AlgoVisualizerTools>(context, listen: false).isVisualizing) {
              return;
            }
            grid.onDragUpdate(i, j, Provider.of<AlgoVisualizerTools>(context, listen: false).curBrush);
          },
          onTapNode: (int i, int j) {
            if(Provider.of<AlgoVisualizerTools>(context, listen: false).isVisualizing) {
              return;
            }
            grid.onTapNode(i, j, Provider.of<AlgoVisualizerTools>(context, listen: false).curBrush);
          },
          child: Stack(
            children: <Widget>[
              StaticGrid(
                columns: grid.columns,
                height: grid.height,
                rows: grid.rows,
                unitSize: grid.unitSize,
                width: grid.width,
              ),
              ChangeNotifierProvider<Painter>.value(
                value: grid.painter,
                child: Selector<Painter, Map<String,Widget>>(
                  shouldRebuild: (Map<String, Widget> a, Map<String, Widget> b) => true,
                  selector: (_, Painter model) => model.visitedNodePainter,
                  builder: (BuildContext context, Map<String, Widget> orders, Widget? child) {
                    return Stack(
                      children: <Widget>[
                        for(Widget order in orders.values)...<Widget>[
                          order,
                        ]
                      ],
                    );
                  }
                ),
              ),
              ChangeNotifierProvider<Painter>.value(
                value: grid.painter,
                child: Selector<Painter, Map<String,Widget>>(
                  shouldRebuild: (Map<String, Widget> a, Map<String, Widget> b) => true,
                  selector: (_, Painter model) => model.pathNodePainter,
                  builder: (BuildContext context, Map<String, Widget> paths, Widget? child) {
                    return Stack(
                      children: <Widget>[
                        for(Widget path in paths.values)...<Widget>[
                          path,
                        ]
                      ],
                    );
                  }
                ),
              ),
              ChangeNotifierProvider<Painter>.value(
                value: grid.painter,
                child: Selector<Painter, List<List<Widget?>> >(
                  shouldRebuild: (List<List<Widget?>> a, List<List<Widget?>> b) => true,
                  selector: (_, Painter model) => model.nodePainter,
                  builder: (BuildContext context, List<List<Widget?>> nodes, Widget? child) {
                    return Stack(
                      children: [
                        for(List<Widget?> list in nodes) ... [
                          for(Widget? node in list)...[
                            if(node != null) ...[
                              node,
                            ]
                          ]
                        ]
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Grid {
  
  Grid({
    required this.startRow,
    required this.startCol,
    required this.endRow,
    required this.endCol,
    required this.rows,
    required this.columns,
    required this.unitSize
  }) {
    nodes = List<List<NodeModel>>.generate(rows, (int row) => List<NodeModel>.generate(columns, (int col) => NodeModel(row: row, col: col, type: NodeType.empty)));
    nodes[startRow][startCol].type = NodeType.start;
    nodes[endRow][endCol].type = NodeType.end;
    width = rows * unitSize;
    height = columns * unitSize;
    painter = Painter(startRow, startCol, endRow, endCol, rows, columns, unitSize);
  }

  int startRow;
  int startCol;
  int endRow;
  int endCol;
  double unitSize;
  late double width;
  late double height;
  late int rows;
  late int columns;
  late List<List<NodeModel>> nodes;
  late Painter painter;
  

  bool isStartOrEnd(int row, int col) {
    if(row == startRow && col == startCol || row == endRow && col == endCol) {
      return true;
    }
    return false;
  }

  void onTapNode(int row, int col, Brush brush) {
    if(isStartOrEnd(row, col)) {
      return;
    }
    NodeModel curNode = nodes[row][col];
    switch (brush) {
      case Brush.wall:
        if(curNode.type == NodeType.wall) {
          curNode.changeNodeType(NodeType.empty);
          painter.removeWidget(row, col);
        } else {
          curNode.changeNodeType(NodeType.wall);
          painter.changeToWallWidget(row, col);
        }
        curNode.weight = 1;
        break;
      case Brush.weight:
        if(curNode.type == NodeType.weight) {
          curNode.weight = 1;
          curNode.changeNodeType(NodeType.empty);
          painter.removeWidget(row, col);
        } else {
          curNode.weight = 5;
          curNode.changeNodeType(NodeType.weight);
          painter.changeToWeightWidget(row, col);
        }
        break;
      case Brush.start:
        NodeModel prevStartNode = nodes[startRow][startCol];
        prevStartNode.changeNodeType(NodeType.empty);
        curNode.weight = 1;
        curNode.changeNodeType(NodeType.start);
        painter.changeToStartWidget(row, col, startRow, startCol);
        startRow = row;
        startCol = col;
        break;
      case Brush.end:
        NodeModel prevStartNode = nodes[endRow][endCol];
        prevStartNode.changeNodeType(NodeType.empty);
        curNode.weight = 1;
        curNode.changeNodeType(NodeType.end);
        painter.changeToEndWidget(row, col, endRow, endCol);
        endRow = row;
        endCol = col;
        break;
    }
  }

  void createNode(int row, int col, NodeType type) {
    NodeModel node = nodes[row][col];
    node.changeNodeType(type);
  }

  void onDragUpdate(int row, int col, Brush brush) {
    onTapNode(row, col, brush);
  }

  void resetPath() {
    for(List<NodeModel> list in nodes) {
      for(NodeModel node in list) {
        node.parent = null;
        node.parent2 = null;
        node.visited = false;
        node.visited2 = false;
        node.distance = 10000;
        if(node.type == NodeType.visiting || node.type == NodeType.pathing) {
          node.changeNodeType(NodeType.empty);
        }
      }
    }
    painter.removePathAndVisited();
  }

  void resetWalls() {
    for(int i = 0; i < nodes.length; i++) {
      for(int j = 0; j < nodes[0].length; j++) {
        nodes[i][j].weight = 1;
        if(nodes[i][j].type == NodeType.wall || nodes[i][j].type == NodeType.weight) {
          nodes[i][j].changeNodeType(NodeType.empty);
          painter.removeWidget(i, j);
        }
      }
    }
  }

  void reset() {
    resetPath();
    resetWalls();
  }

  void randomMaze() {
    Random rng = Random();
    for(int i = 0; i < nodes.length; i++) {
      for(int j = 0; j < nodes[0].length; j++) {
        if(nodes[i][j].type == NodeType.empty) {
          int random = rng.nextInt(6);
          if(random > 4) {
            random = rng.nextInt(6);
            if(random > 3) {
              painter.changeToWallWidget(i, j);
              nodes[i][j].changeNodeType(NodeType.wall);
            } else {
              painter.changeToWeightWidget(i, j);
              nodes[i][j].changeNodeType(NodeType.weight);
              nodes[i][j].weight = 5;
            }
          }
        }
      }
    }
  }
}

class StaticGrid extends StatelessWidget {
  const StaticGrid({
    Key? key,
    required this.rows,
    required this.columns,
    required this.width,
    required this.height,
    required this.unitSize,
  }) : super(key: key);
  
  final int rows;
  final int columns;
  final double width;
  final double height;
  final double unitSize;

  @override
  Widget build(BuildContext context) {
    print('Rebuilding static Grid');
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: GridPainter(rows, columns, unitSize, width, height),
      ),
    );
  }
}
