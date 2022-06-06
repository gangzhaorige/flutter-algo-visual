import 'package:flutter/material.dart';
import 'package:path_visualizer/components/algorithm/algorithm.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:statsfl/statsfl.dart';

import 'components/grid/grid.dart';

void main() {
  runApp(MyApp());
}

enum Brush {
  wall,
  weight,
  start,
  end,
}

// const int rows = 25;
// const int columns = 25;
const double unitSize = 25;
const int startRow = 0;
const int startCol = 0;
const int endRow = 15;
const int endCol = 15;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print();
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => AlgoVisualizerTools(),
        builder: (context, child) {
          int rows = (MediaQuery.of(context).size.width / unitSize / 2).round();
          int columns = (MediaQuery.of(context).size.height / unitSize / 2).round();
          Grid grid = Grid(
            rows: rows,
            columns: columns,
            unitSize: unitSize,
            startRow: startRow,
            startCol: startCol,
            endRow: endRow,
            endCol: endCol,
          );
          return Scaffold(
            appBar: AppBar(
              title: Text('Current Algorithm: ${Provider.of<AlgoVisualizerTools>(context, listen: true).curAlgorithm}'),
            ),
            body: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          grid.resetPath();
                          Algorithms algo = Algorithms(
                            columns: grid.columns,
                            endCol: grid.endCol,
                            endRow: grid.endRow,
                            nodes: grid.nodes,
                            rows: grid.rows,
                            startCol: grid.startCol,
                            startRow: grid.startRow
                          );
                          algo.visualizeAlgorithm(Provider.of<AlgoVisualizerTools>(context, listen: false).curAlgorithm);
                        },
                        child: const Text('Visualize'),
                      ),
                      MaterialButton(
                        onPressed: () => grid.reset(),
                        child: const Text('Reset All'),
                      ),
                      MaterialButton(
                        onPressed: () => grid.resetWalls(),
                        child: const Text('Reset Wall'),
                      ),
                      MaterialButton(
                        onPressed: () => grid.resetPath(),
                        child: const Text('Reset Path'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Provider.of<AlgoVisualizerTools>(context, listen: false).changeBrush(Brush.wall);
                        },
                        child: const Text('Wall Brush'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Provider.of<AlgoVisualizerTools>(context, listen: false).changeBrush(Brush.start);
                        },
                        child: const Text('Start Brush'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Provider.of<AlgoVisualizerTools>(context, listen: false).changeBrush(Brush.end);
                        },
                        child: const Text('End Brush'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<AlgoVisualizerTools>(
                        builder: (context, tools, child) {
                          return MaterialButton(
                            onPressed: () {
                              tools.changeAlgorithm(Algorithm.bfs);
                            },
                            child: const Text('BFS'),
                          );
                        },
                      ),
                      Consumer<AlgoVisualizerTools>(
                        builder: (context, tools, child) {
                          return MaterialButton(
                            onPressed: () {
                              tools.changeAlgorithm(Algorithm.dfs);
                            },
                            child: const Text('DFS'),
                          );
                        },
                      ),
                    ],
                  ),
                  ResponsiveWrapper(
                    child: GridWidget(
                      grid: grid,
                    )
                  )
                ],
              ), 
            ),
          );
        },
      ),
    );
  }
}

enum Algorithm {
  dfs,
  bfs,
}

class AlgoVisualizerTools extends ChangeNotifier {
  Brush curBrush = Brush.start;
  int curSpeed = 5;
  Algorithm curAlgorithm = Algorithm.bfs;

  void changeBrush(Brush type) {
    curBrush = type;
    notifyListeners();
  }

  void changeSpeed(int speed) {
    curSpeed = speed;
    notifyListeners();
  }

  void changeAlgorithm(Algorithm algorithm) {
    curAlgorithm = algorithm;
    notifyListeners();
  }
}

