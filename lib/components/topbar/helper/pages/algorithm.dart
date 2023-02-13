import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/algorithm_changer.dart';
import '../helper.dart';

class AlgorithmHelper extends StatelessWidget {
  const AlgorithmHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return InformationChildWidget(
      title: 'Pick An Algorithm.',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Choose an algorithm from the "Algorithms" section.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          AlgorithmChanger(),
        ],
      ),
    );
  }
}