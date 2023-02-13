import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/coin_switcher.dart';
import 'package:path_visualizer/components/topbar/helper/helper.dart';

class ObstacleHelper extends StatelessWidget {
  const ObstacleHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return InformationChildWidget(
      title: 'Adding Walls and Weights',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Choose a brush to start painting! Click on the grid to paint the grid with the choosen brush.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              text: 'You cannot go through walls, but you can go through the weights at the cost of ',
              children: const <TextSpan>[
                TextSpan(text: '5', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '. Note: Only Dijkstra and A* supports weight.')
              ],
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            'assets/gif/guide.gif',
          ),
        ],
      ),
    );
  }
}