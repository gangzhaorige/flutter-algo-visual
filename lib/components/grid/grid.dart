import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:path_visualizer/components/node/node_model.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../node/node_painter.dart';
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
    return SizedBox(
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
          children: [
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
            ChangeNotifierProvider.value(
              value: grid.walls,
              child: Selector<Painter, Map<String,Widget>>(
                shouldRebuild: (a,b) => true,
                selector: (_, model) => model.map,
                  builder: (context, walls, child) {
                  return Stack(
                    children: [
                      for(Widget wall in walls.values) ...[
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
    nodes = List.generate(rows, (row) => List.generate(columns, (col) => NodeModel(row: row, col: col, type: NodeType.empty)));
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
  final int rows;
  final int columns;
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
          walls.addWall(row, col, unitSize, createWall);
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

  void createWall(int row, int col) {
    NodeModel node = nodes[row][col];
    node.changeNodeType(NodeType.wall);
  }

  void onDragUpdate(int row, int col, Brush brush) {
    onTapNode(row, col, brush);
  }

  void reset() {
    for(List<NodeModel> list in nodes) {
      for(NodeModel node in list) {
        node.parent = null;
        if(node.visited) {
          node.visited = false;
        }
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
        if(isStartOrEnd(node.row, node.col)) {
          continue;
        }
        if(node.type == NodeType.visiting || node.type == NodeType.pathing) {
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
        } else if(node.type == NodeType.empty && !isStartOrEnd(node.row, node.col)) {
          if(node.type != NodeType.empty) {
            node.changeNodeType(NodeType.empty);
          }
        }
        node.parent = null;
        node.visited = false;
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
    return Stack(
      children: [
        for(int i = 0; i < grid.nodes.length; i++)...[
          for(int j = 0; j < grid.nodes[0].length; j++) ...[
            ChangeNotifierProvider.value(
              value: grid.nodes[i][j],
              child: Selector<NodeModel, NodeType>(
                selector: (_, type) => grid.nodes[i][j].type,
                  builder: (context, type, child) {
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
