import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../algorithm/algorithm.dart';
import '../drawer_child.dart';

class CoinSwitcher extends StatelessWidget {
  const CoinSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerChild(
      category: 'Coin Switcher',
      action: Selector<AlgoVisualizerTools, bool>(
        selector: (_, AlgoVisualizerTools model) => model.hasCoin,
        builder: (BuildContext context, bool hasCoin, Widget? child) {
          return Material(
            child: Switch(
              value: hasCoin,
              onChanged: (bool value) => Provider.of<AlgoVisualizerTools>(context, listen: false).toggleCoin(),
            ),
          );
        }
      ),
      icon: Icons.change_circle,
    );
  }

}