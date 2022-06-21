import 'package:flutter/material.dart';

import 'widgets/algorithm_changer.dart';
import 'widgets/brush_changer.dart';
import 'widgets/speed_changer.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rebuilding AppDrawer');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          AlgorithmChanger(),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
          SpeedChanger(),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
          BrushChanger(),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}