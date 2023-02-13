import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/diagonal_switcher.dart';
import 'package:path_visualizer/components/topbar/helper/helper.dart';

class DirectionHelper extends StatelessWidget {
  const DirectionHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return InformationChildWidget(
      title: 'Toggle between 4 and 8 directional movement.',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              children: const <TextSpan>[
                TextSpan(text: 'In a weighted algorithm moving diagonally costs '),
                TextSpan(text: '1.1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'times than usual. Which means '),
                TextSpan(text: '1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'to '),
                TextSpan(text: '1.1. ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'In a unweight algorithm it is '),
                TextSpan(text: '1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'to '),
                TextSpan(text: '1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'meaning moving diagonally is the same cost as moving horizontally or vertically.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const DirectionSwitcher(),
        ],
      ),
    );
  }
}