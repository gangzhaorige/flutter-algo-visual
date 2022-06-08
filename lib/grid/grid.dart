import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../node/node_model.dart';
import '../../node/node_painter.dart';
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
              StaticNodeGrid(
                grid: grid,
              ),
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
                  selector: (_, Painter model) => model.nodes,
                    builder: (BuildContext context, Map<String, Widget> walls, Widget? child) {
                    return Stack(
                      children: [
                        for(Widget wall in walls.values)...<Widget>[
                          wall,
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
                  selector: (_, Painter model) => model.weightNodes,
                    builder: (BuildContext context, Map<String, Widget> weights, Widget? child) {
                    return Stack(
                      children: [
                        for(Widget weight in weights.values)...<Widget>[
                          weight,
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

class Grid extends ChangeNotifier{
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
    painter = Painter();
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
        } else {
          painter.addNodeWidget(row, col, unitSize, createNode, NodeType.wall);
        }
        curNode.weight = 0;
        painter.removeWeight(row, col);
        break;
      case Brush.weight:
        if(curNode.type == NodeType.weight) {
          curNode.weight = 0;
          curNode.changeNodeType(NodeType.empty);
          painter.removeWeight(row, col);
        } else {
          curNode.weight = 5;
          curNode.changeNodeType(NodeType.weight);
          painter.addWeightWidget(row, col, unitSize);
        }
        break;
      case Brush.start:
        NodeModel prevStartNode = nodes[startRow][startCol];
        prevStartNode.changeNodeType(NodeType.empty);
        startRow = row;
        startCol = col;
        curNode.weight = 0;
        curNode.changeNodeType(NodeType.start);
        painter.removeWeight(row, col);
        break;
      case Brush.end:
        NodeModel prevStartNode = nodes[endRow][endCol];
        prevStartNode.changeNodeType(NodeType.empty);
        endRow = row;
        endCol = col;
        curNode.weight = 0;
        curNode.changeNodeType(NodeType.end);
        painter.removeWeight(row, col);
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
  }

  void resetWalls() {
    for(int i = 0; i < nodes.length; i++) {
      for(int j = 0; j < nodes[0].length; j++) {
        nodes[i][j].weight = 0;
        if(nodes[i][j].type == NodeType.wall || nodes[i][j].type == NodeType.weight) {
          nodes[i][j].changeNodeType(NodeType.empty);
        }
      }
    }
    painter.removeAllWeightNodes();
  }

  void randomMaze() {
    Random rng = Random();
    for(int i = 0; i < nodes.length; i++) {
      for(int j = 0; j < nodes[0].length; j++) {
        if(nodes[i][j].type == NodeType.empty) {
          int random = rng.nextInt(5);
          if(random > 3) {
            painter.addNodeWidget(i, j, unitSize, createNode, NodeType.wall);
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

class StaticNodeGrid extends StatelessWidget {
  const StaticNodeGrid({
    Key? key,
    required this.grid,
  }) : super(key: key);

  final Grid grid;
  @override
  Widget build(BuildContext context) {
    print('Rebuilding Static Node Grid');
    return Stack(
      children: <Widget>[
        for(int i = 0; i < grid.nodes.length; i++)...[
          for(int j = 0; j < grid.nodes[0].length; j++) ...[
            ChangeNotifierProvider<NodeModel>.value(
              value: grid.nodes[i][j],
              child: Selector<NodeModel, NodeType>(
                selector: (_, NodeModel type) => grid.nodes[i][j].type,
                builder: (BuildContext context, NodeType type, Widget? child) {
                  return Positioned(
                    left: i * (grid.unitSize.toDouble()),
                    top:  j * (grid.unitSize.toDouble()),
                    child: SquareWidget(
                      type: type,
                      row: i,
                      col: j,
                      unitSize: grid.unitSize,
                    ),
                  );
                }
              ),
            ),
          ],
        ],
      ],
    );
  }
}
