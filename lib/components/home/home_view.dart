import 'package:flutter/material.dart';
import 'package:path_visualizer/components/home/home_view_mobile.dart';
import 'package:path_visualizer/components/home/home_view_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../algorithm/algorithm.dart';
import '../drawer/drawer.dart';

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
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const AppDrawer(),
      body: OrientationLayoutBuilder(
        portrait: (BuildContext context) => const HomeViewMobile(),
        landscape: (BuildContext context) => const HomeViewTablet(),
      ),
    );
  }
}