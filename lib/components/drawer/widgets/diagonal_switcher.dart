import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../algorithm/algorithm.dart';
import '../../../node/coin_painter.dart';
import '../../../node/start_end_painter.dart';
import '../drawer_child.dart';


final List<List<String>> textDirection = [
  ['UL', 'U', 'UR'],
  ['L','','R'],
  ['DL','D','DR'],
];

class DirectionSwitcher extends StatelessWidget {
  const DirectionSwitcher({Key? key}) : super(key: key);

  bool isDiagonalDirection(String str) {
    return str == 'UL' || str == 'UR' || str == 'DL' || str == 'DR'; 
  }

  @override
  Widget build(BuildContext context) {
    return DrawerChild(
      category: 'Direction Switcher',
      action: Selector<AlgoVisualizerTools, bool>(
        selector: (_, AlgoVisualizerTools model) => model.getIsDiagonal(),
        builder: (BuildContext context, bool hasDiagonalDirection, Widget? child) {
          List<List<String>> list = textDirection;
          return Material(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for(int i = 0; i < 3; i++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for(int j = 0; j < 3; j++) ...[
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: list[i][j] != '' ? CustomPaint(
                                  painter: TextCircularPainter(
                                    fraction: 1,
                                    unitSize: 30,
                                    text: list[i][j],
                                    color: (() {
                                      if(!isDiagonalDirection(list[i][j])) {
                                        if(hasDiagonalDirection) {
                                          return Colors.green;
                                        }
                                        return Colors.blue;
                                      }
                                      if(hasDiagonalDirection) {
                                        if(isDiagonalDirection(list[i][j])) {
                                          return Colors.blue;
                                        }
                                      }
                                      return Colors.grey;
                                    } ())
                                  ),
                                ) : null,
                              ),
                            ],
                          ],
                        ),
                      ]
                    ],
                  ),
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