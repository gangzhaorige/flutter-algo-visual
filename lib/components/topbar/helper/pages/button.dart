import 'package:flutter/material.dart';
import 'package:path_visualizer/components/topbar/helper/helper.dart';

class ButtonNav extends StatelessWidget {
  const ButtonNav({super.key});

  @override
  Widget build(BuildContext context) {
    return InformationChildWidget(
      title: 'Visualize and More',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Use the bottom navigation to help yourself!',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'First: Reset All \n Second: Reset Wall \n Third: Visualize Algorithm \n Fourth: Reset Path \n Fifth: Generate Random Maze',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            'assets/images/nav.png',
            height: 100,
          ),
        ],
      ),
    );
  }
}