import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../algorithm/algorithm.dart';
import '../../grid/grid.dart';
import '../bottom_nav/bottom_nav.dart';
import '../drawer/drawer.dart';
import '../topbar/top_bar.dart';

const Map<Algorithm, String> algoName = <Algorithm,String>{
  Algorithm.bfs : 'Breadth First Search',
  Algorithm.dfs : 'Depth First Search',
  Algorithm.biBfs : 'Bidirectional BFS',
  Algorithm.dijkstra : 'Dijkstra',
  Algorithm.aStar : 'A* Search',
};

final AlgoVisualizerTools algo = AlgoVisualizerTools();

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double unitSize = 30; 
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        int rows = constraint.maxWidth ~/ unitSize;
        int columns = (constraint.maxHeight - 70 - 55 - 50) ~/ unitSize;
        Grid grid = Grid(
          startRow: rows ~/ 2 - rows ~/ 2.5,
          startCol: columns ~/ 2,
          endRow: rows ~/ 2 + rows ~/ 2.5 - 1,
          endCol: columns ~/ 2,
          rows: rows,
          columns: columns,
          unitSize: unitSize,
        );
        return Scaffold(
          drawerEnableOpenDragGesture: false,
          drawer: const AppDrawer(),
          body: Column(
            children: <Widget>[
              const TopBar(),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Selector<AlgoVisualizerTools, Algorithm>(
                          selector: (_, AlgoVisualizerTools model) => model.getCurAlgorithm(),
                          builder: (BuildContext context, Algorithm algo, Widget? child) {
                            return Text(
                              '${algoDescription[algo]}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            );
                          }
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridWidget(
                          grid: grid,
                        ),
                      ),
                    ),
                    BottomNav(grid: grid),
                  ],
                ),
              ),
            ],
          ),
        );

      },
    );
  }
}