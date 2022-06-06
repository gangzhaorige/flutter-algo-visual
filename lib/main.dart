import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_visualizer/components/home/home_view.dart';
import 'package:statsfl/statsfl.dart';
import 'grid/grid.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      StatsFl(
        child: const MyApp(),
      )
    )
  );
}

enum Brush {
  wall,
  weight,
  start,
  end,
}

// const int rows = 25;
// const int columns = 25;
// const double unitSize = 25;
// const int startRow = 0;
// const int startCol = 0;
// const int endRow = 15;
// const int endCol = 15;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.blue,
        child: const SafeArea(
          child: HomeView()
        ),
      ),
    );
  }
}

          // Grid grid = Grid(
          //   rows: rows,
          //   columns: columns,
          //   unitSize: unitSize,
          //   startRow: startRow,
          //   startCol: startCol,
          //   endRow: endRow,
          //   endCol: endCol,
          // );

// Scaffold(
//                 appBar: AppBar(
//                   title: Text('Current Algorithm: ${Provider.of<AlgoVisualizerTools>(context, listen: false).curAlgorithm}'),
//                 ),
//                 body: Center(
//                   child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           MaterialButton(
//                             onPressed: () {
//                               grid.resetPath();
//                               Algorithms algo = Algorithms(
//                                 columns: grid.columns,
//                                 endCol: grid.endCol,
//                                 endRow: grid.endRow,
//                                 nodes: grid.nodes,
//                                 rows: grid.rows,
//                                 startCol: grid.startCol,
//                                 startRow: grid.startRow
//                               );
//                               algo.visualizeAlgorithm(Provider.of<AlgoVisualizerTools>(context, listen: false).curAlgorithm);
//                             },
//                             child: const Text('Visualize'),
//                           ),
//                           MaterialButton(
//                             onPressed: () => grid.reset(),
//                             child: const Text('Reset All'),
//                           ),
//                           MaterialButton(
//                             onPressed: () => grid.resetWalls(),
//                             child: const Text('Reset Wall'),
//                           ),
//                           MaterialButton(
//                             onPressed: () => grid.resetPath(),
//                             child: const Text('Reset Path'),
//                           ),
//                           MaterialButton(onPressed: () => Provider.of<AlgoVisualizerTools>(context, listen: false).changeBrush(Brush.wall),
//                             child: const Text('Change to Wall'),
//                           ),
//                           MaterialButton(onPressed: () => Provider.of<AlgoVisualizerTools>(context, listen: false).changeBrush(Brush.start),
//                             child: const Text('Change to Start'),
//                           ),
//                         ],
//                       ),
//                       ResponsiveWrapper(
//                         child: GridWidget(
//                           grid: grid,
//                         )
//                       )
//                     ],
//                   ), 
//                 ),
//               );

enum Algorithm {
  dfs,
  bfs,
}

class AlgoVisualizerTools extends ChangeNotifier {

  AlgoVisualizerTools({
    required this.rows,
    required this.columns,
    required this.unitSize,
  }) {
    grid = Grid(
      rows: rows,
      columns: columns,
      unitSize: unitSize,
      startRow: 0,
      startCol: 0,
      endRow: rows ~/ 2,
      endCol: columns ~/ 2,
    );
  }

  final int rows;
  final int columns;
  final double unitSize;
  late Grid grid;

  Brush curBrush = Brush.wall;
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

