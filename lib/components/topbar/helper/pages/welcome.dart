import 'package:flutter/material.dart';
import '../helper.dart';

class WelcomeHelper extends StatelessWidget {
  const WelcomeHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return InformationChildWidget(
      title: 'Welcome to Path Visualizer',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'This short tutorial will walk you through all of the features of this application.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'If you want to dive right in, feel free to press the "Skip Tutorial" button below. Otherwise, press "Next"!',
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.flag_circle,
            size: 100,
            color: Theme.of(context).indicatorColor,
          ),
        ],
      ),
    );
  }
}