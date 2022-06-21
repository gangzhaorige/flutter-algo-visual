import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../algorithm/algorithm.dart';
import '../drawer_child.dart';

const double min = 10;
const double max = 90;

class SpeedChanger extends StatelessWidget {
  const SpeedChanger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerChild(
      icon: Icons.speed, 
      category: 'Speed',
      action: Selector<AlgoVisualizerTools, double>(
        selector: (_, AlgoVisualizerTools model) => model.curSpeed,
        builder: (BuildContext context, double curSpeed, Widget? child) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const<Widget>[
                    Text('Slower'),
                    Text('Render Speed'),
                    Text('Faster'),
                  ],
                ),
              ),
              Slider(
                min: min,
                max: max,
                onChanged: (double value) {
                  double reverse = (value - max).abs() + min;
                  Provider.of<AlgoVisualizerTools>(context, listen: false).changeSpeed(reverse);
                },
                value: (curSpeed - max).abs() + min,
                divisions: 2,
              ),
            ],
          );
        }
      ),
    );
  }
}