import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../algorithm/algorithm.dart';
import '../../../node/coin_painter.dart';
import '../../../node/start_end_painter.dart';
import '../drawer_child.dart';

class CoinSwitcher extends StatelessWidget {
  const CoinSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerChild(
      category: 'Coin Switcher',
      action: Selector<AlgoVisualizerTools, bool>(
        selector: (_, AlgoVisualizerTools model) => model.getCoin(),
        builder: (BuildContext context, bool hasCoin, Widget? child) {
          return Material(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CustomPaint(
                          painter: StartPainter(
                            fraction: 1,
                            unitSize: 30,
                          ),
                        )
                      ),
                      if(hasCoin) ...[
                        const Icon(
                          Icons.arrow_right
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CustomPaint(
                            painter: CoinPainter(
                              fraction: 1,
                              unitSize: 30,
                            ),
                          )
                        ),
                      ],
                      const Icon(
                        Icons.arrow_right
                      ),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CustomPaint(
                          painter: EndPainter(
                            fraction: 1,
                            unitSize: 30,
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: hasCoin,
                  onChanged: (bool value) => Provider.of<AlgoVisualizerTools>(context, listen: false).toggleCoin(),
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