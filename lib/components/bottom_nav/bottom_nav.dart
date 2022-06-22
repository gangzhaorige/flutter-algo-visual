import 'package:flutter/material.dart';
import 'package:path_visualizer/my_icon_icons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../algorithm/algorithm.dart';
import '../../grid/grid.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key, required this.grid})  : super(key: key);

  final Grid grid;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = <Widget>[
      Consumer<AlgoVisualizerTools>(
        builder: (BuildContext context, AlgoVisualizerTools tool, Widget? child) {
          return GestureDetector(
            onTap: tool.isVisualizing ? null : () => grid.reset(),
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255,119,182,255),
                shape: BoxShape.circle
              ),
              child: Center(
                child: Icon(
                  Icons.restart_alt,
                  color: tool.isVisualizing ? Colors.red : Colors.white,
                )
              ),
            ),
          );
        },
      ),
      Consumer<AlgoVisualizerTools>(
        builder: (BuildContext context, AlgoVisualizerTools tool, Widget? child) {
          return GestureDetector(
            onTap: tool.isVisualizing ? null : () => grid.resetWalls(),
            child: Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255,119,182,255),
                shape: BoxShape.circle
              ),
              child: Center(
                child: Icon(
                  MyIcon.resetWall,
                  color: tool.isVisualizing ? Colors.red : Colors.white,
                  size: 30,
                )
              ),
            ),
          );
        },
      ),
      Consumer<AlgoVisualizerTools>(
        builder: (BuildContext context, AlgoVisualizerTools tool, Widget? child) {
          return GestureDetector(
            onTap: tool.isVisualizing ? null : () {
              grid.resetPath(true);
              Algorithms algo = Algorithms(
                columns: grid.columns,
                endCol: grid.endCol,
                endRow: grid.endRow,
                nodes: grid.nodes,
                rows: grid.rows,
                startCol: grid.startCol,
                startRow: grid.startRow,
                coinRow: grid.coinRow,
                coinCol: grid.coinCol,
                grid: grid,
              );
              AlgoVisualizerTools tool = Provider.of<AlgoVisualizerTools>(context, listen: false);
              algo.visualizeAlgorithm(
                tool.getCurAlgorithm(),
                tool.curSpeed.toInt(),
                tool.toggleVisualizing,
                tool.hasCoin,
              );
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255,119,182,255),
                shape: BoxShape.circle
              ),
              child: Center(
                child: Text(
                  'V',
                  style: TextStyle(
                    fontSize: 25,
                    color: tool.isVisualizing ? Colors.red : Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          );
        },
      ),
      Consumer<AlgoVisualizerTools>(
        builder: (BuildContext context, AlgoVisualizerTools tool, Widget? child) {
          return GestureDetector(
            onTap: tool.isVisualizing ? null : () => grid.resetPath(true),
            child: Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255,119,182,255),
                shape: BoxShape.circle
              ),
              child: Center(
                child: Icon(
                  MyIcon.resetPath,
                  color: tool.isVisualizing ? Colors.red : Colors.white,
                  size: 30,
                )
              ),
            ),
          );
        },
      ),
      Consumer<AlgoVisualizerTools>(
        builder: (BuildContext context, AlgoVisualizerTools tool, Widget? child) {
          return GestureDetector(
            onTap: tool.isVisualizing ? null : () => grid.randomMaze(),
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255,119,182,255),
                shape: BoxShape.circle
              ),
              child: Center(
                child: Icon(
                  MyIcon.maze,
                  color: tool.isVisualizing ? Colors.red : Colors.white,
                )
              ),
            ),
          );
        },
      ),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 35,
                ),
                Container(
                  height: 35,
                  color: Colors.blue,
                ),
              ],
            ),
            ScreenTypeLayout(
              mobile: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for(Widget widget in list)...<Widget>[
                    widget,
                  ]
                ],
              ),
              tablet: Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.vertical,
                runSpacing: 50,
                children: <Widget>[
                  for(Widget widget in list)...<Widget>[
                    widget,
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}