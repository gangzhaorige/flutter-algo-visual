import 'package:flutter/material.dart';
import 'package:path_visualizer/node/node_model.dart';
import 'package:path_visualizer/node/node_painter.dart';
import 'package:provider/provider.dart';

import '../../algorithm/algorithm.dart';
import '../../grid/grid.dart';
import '../drawer/drawer.dart';
import '../topbar/top_bar.dart';

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
                    int rows = constraint.maxWidth ~/ unitSize + 1;
                    int columns = constraint.maxHeight ~/ unitSize + 1;
                    grid = Grid(
                      startRow: 0,
                      startCol: 0,
                      endRow: rows - 1,
                      endCol: columns - 1,
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
              // bottom bar
              Container(
                height: 55,
                color: Colors.blue,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          grid.resetPath();
                        },
                        child: const Text('Reset Path'),
                      ),
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
                            startRow: grid.startRow,
                            grid: grid,
                          );
                          AlgoVisualizerTools tool = Provider.of<AlgoVisualizerTools>(context, listen: false);
                          algo.visualizeAlgorithm(
                            tool.curAlgorithm,
                            tool.curSpeed,
                          );
                        },
                        child: const Text('Visualize'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          grid.resetWalls();
                        },
                        child: const Text('Reset Wall'),
                      ),
                    ],
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