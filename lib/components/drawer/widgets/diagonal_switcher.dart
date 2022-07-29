import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../algorithm/algorithm.dart';
import '../../../node/coin_painter.dart';
import '../../../node/start_end_painter.dart';
import '../drawer_child.dart';


List<List<String>> textDirection = [
  ['UL', 'U', 'UR'],
  ['L','','R'],
  ['DL','D','DR'],
];

List<List<String>> textDirection2 = [
  ['', 'U', ''],
  ['L','','R'],
  ['','D',''],
];

class DirectionSwitcher extends StatelessWidget {
  const DirectionSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerChild(
      category: 'Direction Switcher',
      action: Selector<AlgoVisualizerTools, bool>(
        selector: (_, AlgoVisualizerTools model) => model.getIsDiagonal(),
        builder: (BuildContext context, bool hasDiagonalDirection, Widget? child) {
          List<List<String>> list = hasDiagonalDirection ? textDirection : textDirection2; 
          return Material(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for(int i = 0; i < 3; i++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for(int j = 0; j < 3; j++) ...[
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: list[i][j] != '' ? CustomPaint(
                                    painter: TextCircularPainter(
                                      fraction: 1,
                                      unitSize: 30,
                                      text: list[i][j],
                                    ),
                                  ) : null,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ]
                    ],
                  )
                ),
                Switch(
                  value: hasDiagonalDirection,
                  onChanged: (bool value) => Provider.of<AlgoVisualizerTools>(context, listen: false).setDiagonal(!hasDiagonalDirection),
                ),
              ],
            ),
          );
        }
      ),
      icon: Icons.change_circle,
    );
  }

}