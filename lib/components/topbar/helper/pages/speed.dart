import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/speed_changer.dart';
import 'package:path_visualizer/components/topbar/helper/helper.dart';

class SpeedHelper extends StatelessWidget {
  const SpeedHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return InformationChildWidget(
      title: 'Render Speed.',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Slide between Slow and Fast',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Path rendering speed. Gotta Go Fast!',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          SpeedChanger(),
        ],
      ),
    );
  }
}