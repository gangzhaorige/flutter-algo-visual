import 'package:flutter/material.dart';
import 'package:path_visualizer/main.dart';
import 'package:provider/provider.dart';

import '../../algorithm/algorithm.dart';

class TopBarMobile extends StatelessWidget {
  const TopBarMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        const Text(
          'Path Visualizer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Provider.of<AlgoVisualizerTools>(context, listen: false).changeBrush(Brush.start);
            },
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}