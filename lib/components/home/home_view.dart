import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../algorithm/algorithm.dart';
import '../../grid/grid.dart';
import '../bottom_nav/bottom_nav.dart';
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
    Grid grid = Grid(
      startRow: 0,
      startCol: 0,
      endRow: 1,
      endCol: 1,
      rows: 2,
      columns: 2,
      unitSize: unitSize,
    );
    return ChangeNotifierProvider<AlgoVisualizerTools>.value(
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          drawerEnableOpenDragGesture: false,
          drawer: const AppDrawer(),
          body: Column(
            children: <Widget>[
              // top bar
              const TopBar(),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraint) {
                    print('Rebuilding LayOutBuilder');
                    int rows = constraint.maxWidth ~/ unitSize - 1;
                    int columns = (constraint.maxHeight - 70)  ~/ unitSize - 1;
                    grid = Grid(
                      startRow: rows ~/ 2 - rows ~/ 2.5,
                      startCol: columns ~/ 2,
                      endRow: rows ~/ 2 + rows ~/ 2.5,
                      endCol: columns ~/ 2,
                      rows: rows,
                      columns: columns,
                      unitSize: unitSize,
                    );
                    return Column(
                      children: [
                        // main body
                        Expanded(
                          child: GridWidget(
                            grid: grid,
                          ),
                        ),
                        // navbar
                        BottomNav(grid: grid),
                      ],
                    );
                  },
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