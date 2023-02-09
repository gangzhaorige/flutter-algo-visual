import 'package:flutter/material.dart';
import 'package:path_visualizer/my_icon_icons.dart';
import 'package:provider/provider.dart';

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
            onTap: tool.getVisualizing() ? null : () => grid.reset(),
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
                  color: tool.getVisualizing() ? Colors.red : Colors.white,
                )
              ),
            ),
          );
        },
      ),
      Consumer<AlgoVisualizerTools>(
        builder: (BuildContext context, AlgoVisualizerTools tool, Widget? child) {
          return GestureDetector(
            onTap: tool.getVisualizing() ? null : () => grid.resetWalls(),
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
                  color: tool.getVisualizing() ? Colors.red : Colors.white,
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
            onTap: tool.getVisualizing() ? null : () {
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
                tool.getAlgorithm(),
                tool.getSpeed().toInt(),
                tool.toggleVisualizing,
                tool.getCoin(),
                tool.getIsDiagonal(),
                tool.setLengthPath,
              ).then((_) => {
                showAlert(context, tool.getLengthPath()),
                tool.setLengthPath(0),
              });
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
                    color: tool.getVisualizing() ? Colors.red : Colors.white,
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
            onTap: tool.getVisualizing() ? null : () => grid.resetPath(true),
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
                  color: tool.getVisualizing() ? Colors.red : Colors.white,
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
            onTap: tool.getVisualizing() ? null : () => grid.randomMaze(),
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
                  color: tool.getVisualizing() ? Colors.red : Colors.white,
                )
              ),
            ),
          );
        },
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          height: 70,
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.vertical,
            runSpacing: 35,
            children: <Widget>[
              for(Widget widget in list)...<Widget>[
                widget,
              ]
            ],
          ),
        ),
      ),
    );
  }

  void showAlert(BuildContext context, int shortestPath) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        bool isVisible = true;
        Future<dynamic>.delayed(const Duration(seconds: 3)).then((value) {
          if (isVisible) {
            Navigator.of(context).pop();
          }
        });
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('The Length of the shortest path is $shortestPath block(s).'),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    isVisible = false;
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}