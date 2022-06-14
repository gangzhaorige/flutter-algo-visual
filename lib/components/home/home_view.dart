import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../algorithm/algorithm.dart';
import '../../grid/grid.dart';
import '../drawer/drawer.dart';
import '../topbar/top_bar.dart';

const Map<Algorithm, String> algoName = {
  Algorithm.bfs : 'Breadth First Search',
  Algorithm.dfs : 'Depth First Search',
  Algorithm.biBfs : 'Bidirectional BFS',
  Algorithm.dijkstra : 'Dijkstra',
};

final AlgoVisualizerTools algo = AlgoVisualizerTools();

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rebuilding HomeView');
    const double unitSize = 25; 
    late Grid grid;
    return ChangeNotifierProvider<AlgoVisualizerTools>.value(
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          drawerEnableOpenDragGesture: false,
          drawer: const AppDrawer(),
          body: Column(
            children: <Widget>[
              const TopBar(),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraint) {
                    print('Rebuilding LayOutBuilder');
                    int rows = constraint.maxWidth ~/ unitSize - 1;
                    int columns = constraint.maxHeight ~/ unitSize - 1;
                    grid = Grid(
                      startRow: rows ~/ 2 - rows ~/ 2.5,
                      startCol: columns ~/ 2,
                      endRow: rows ~/ 2 + rows ~/ 2.5,
                      endCol: columns ~/ 2,
                      rows: rows,
                      columns: columns,
                      unitSize: unitSize,
                    );
                    return GridWidget(
                      grid: grid,
                    );
                  },
                ),
              ),
              Container(
                height: 55,
                color: Colors.blue,
                child: Center(
                  child: Selector<AlgoVisualizerTools, bool>(
                    selector: (_, AlgoVisualizerTools model) => model.isVisualizing,
                    builder: (BuildContext context, bool isVisualizing, Widget? child) {
                      print('rebuilding row...');
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: isVisualizing ? null : () {
                                grid.resetPath();
                              },
                              child: const Text('Reset Path'),
                            ),
                            MaterialButton(
                              onPressed: isVisualizing ? null : () {
                                grid.resetPath();
                                Algorithms algo = Algorithms(
                                  columns: grid.columns,
                                  endCol: grid.endCol,
                                  endRow: grid.endRow,
                                  nodes: grid.nodes,
                                  rows: grid.rows,
                                  startCol: grid.startCol,
                                  startRow: grid.startRow,
                                  grid: grid,
                                );
                                AlgoVisualizerTools tool = Provider.of<AlgoVisualizerTools>(context, listen: false);
                                algo.visualizeAlgorithm(
                                  tool.curAlgorithm,
                                  tool.curSpeed.toInt(),
                                  tool.toggleVisualizing,
                                );
                              },
                              child: Text(isVisualizing ? 'Visualizing' : 'Visualize'),
                            ),
                            MaterialButton(
                              onPressed: isVisualizing ? null : () {
                                grid.resetWalls();
                              },
                              child: const Text('Reset Wall'),
                            ),
                            MaterialButton(
                              onPressed: isVisualizing ? null : () {
                                grid.randomMaze();
                              },
                              child: const Text('Generate Maze'),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        );
      }, 
      value: algo,
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.dfs);
                Navigator.pop(context);
              },
              child: const Text('DFS'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.bfs);
                Navigator.pop(context);
              },
              child: const Text('BFS'),
            ),
          ],
        ),
      ),
    );
  }
}