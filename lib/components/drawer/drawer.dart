import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/coin_switcher.dart';
import 'package:path_visualizer/components/drawer/widgets/diagonal_switcher.dart';
import 'package:path_visualizer/components/drawer/widgets/theme_switcher.dart';
import 'package:path_visualizer/components/drawer/widgets/tools.dart';

import 'widgets/algorithm_changer.dart';
import 'widgets/brush_changer.dart';
import 'widgets/speed_changer.dart';

const List<Widget> drawerWidget = <Widget>[
  AlgorithmChanger(),
  SpeedChanger(),
  BrushChanger(),
  CoinSwitcher(),
  DirectionSwitcher(),
  ThemeSwitcher(),
];

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: ToolWidgets(),
    );
  }
}