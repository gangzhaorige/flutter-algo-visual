import 'package:flutter/material.dart';
import 'package:path_visualizer/algorithm/algorithm.dart';
import 'package:path_visualizer/components/drawer/widgets/coin_switcher.dart';
import 'package:provider/provider.dart';

import 'widgets/algorithm_changer.dart';
import 'widgets/brush_changer.dart';
import 'widgets/speed_changer.dart';

const List<Widget> drawerWidget = [
  AlgorithmChanger(),
  SpeedChanger(),
  BrushChanger(),
  CoinSwitcher(),
];

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rebuilding AppDrawer');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          for(Widget widget in drawerWidget) ...[
            widget,
            const Divider(
              thickness: 1,
              color: Colors.blue,
            ),
          ],
        ],
      ),
    );
  }
}