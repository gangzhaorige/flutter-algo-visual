import 'package:flutter/material.dart';
import 'package:path_visualizer/main.dart';
import 'package:provider/provider.dart';

import '../../../algorithm/algorithm.dart';
import '../../../node/coin_painter.dart';
import '../../../node/start_end_painter.dart';
import '../drawer_child.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerChild(
      category: 'Theme Switcher',
      action: Selector<ThemeNotifier, bool>(
        selector: (_, ThemeNotifier theme) => theme.isLight(),
        builder: (BuildContext context, bool isLight, Widget? child) {
          return Builder(
            builder: (context) {
              return Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Switch(
                  value: isLight,
                  onChanged: (bool value) => Provider.of<ThemeNotifier>(context, listen: false).toggle(),
                ),
              );
            }
          );
        }
      ),
      icon: Icons.change_circle,
    );
  }

}