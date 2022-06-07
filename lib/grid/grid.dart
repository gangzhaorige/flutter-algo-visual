import 'dart:collection';

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
            grid.onDragUpdate(i, j, Provider.of<AlgoVisualizerTools>(context, listen: false).curBrush);
          },
          onTapNode: (int i, int j) {
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
              StaticNodeGrid(
                grid: grid,
              ),
              ChangeNotifierProvider<Painter>.value(
                value: grid.walls,
                child: Selector<Painter, Map<String,Widget>>(
                  shouldRebuild: (Map<String, Widget> a, Map<String, Widget> b) => true,
                  selector: (_, Painter model) => model.map,
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
    walls = Painter();
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
  late Painter walls;

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
          walls.addNodeWiget(row, col, unitSize, createNode, NodeType.wall);
        }
        break;
      case Brush.weight:
        // TODO: Handle this case.
        break;
      case Brush.start:
        NodeModel prevStartNode = nodes[startRow][startCol];
        prevStartNode.changeNodeType(NodeType.empty);
        startRow = row;
        startCol = col;
        curNode.changeNodeType(NodeType.start);
        break;
      case Brush.end:
        NodeModel prevStartNode = nodes[endRow][endCol];
        prevStartNode.changeNodeType(NodeType.empty);
        endRow = row;
        endCol = col;
        curNode.changeNodeType(NodeType.end);
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

  void resetGrid() {
    for(List<NodeModel> list in nodes) {
      for(NodeModel node in list) {
        node.parent = null;
        node.visited = false;
        if(isStartOrEnd(node.row, node.col)) {
          continue;
        }
        node.changeNodeType(NodeType.empty);
      }
    }
  }

  void resetPath() {
    for(List<NodeModel> list in nodes) {
      for(NodeModel node in list) {
        node.parent = null;
        node.visited = false;
        if(node.type == NodeType.visiting || node.type == NodeType.pathing || node.type == NodeType.weight) {
          node.changeNodeType(NodeType.empty);
        }
      }
    }
  }

  void resetWalls() {
    for(List<NodeModel> list in nodes) {
      for(NodeModel node in list) {
        if(node.type == NodeType.wall) {
          node.changeNodeType(NodeType.empty);
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
                    child: RepaintBoundary(
                      child: SquareWidget(
                        type: type,
                        row: i,
                        col: j,
                        unitSize: grid.unitSize,
                      ),
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
