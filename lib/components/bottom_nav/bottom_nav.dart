import 'package:flutter/material.dart';
import 'package:path_visualizer/components/animated_button.dart';
import 'package:path_visualizer/components/border_button.dart';

import '../../grid/grid.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key, required this.grid})  : super(key: key);

  final Grid grid;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = <Widget>[
      BorderButton(
        onPressed: grid.reset,
        text: 'Reset All',
      ),
      BorderButton(
        onPressed: grid.resetWalls,
        text: 'Reset Walls',
      ),
      AnimatedButton(
        grid: grid,
      ),
      BorderButton(
        onPressed: grid.resetPathVisual,
        text: 'Reset Paths',
      ),
      BorderButton(
        onPressed: grid.randomMaze,
        text: 'Random Maze',
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          height: 100,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 30,
            spacing: 30,
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
}