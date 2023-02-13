
import 'package:flutter/material.dart';
import 'package:path_visualizer/algorithm/algorithm.dart';
import 'package:provider/provider.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({super.key, required this.onPressed, required this.text});

  final Function onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Consumer<AlgoVisualizerTools>(
      builder: (BuildContext context, AlgoVisualizerTools tool, Widget? child) {
        return Container(
          width: 120,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).indicatorColor,
            )
          ),
          child: TextButton(
            onPressed: () {
              if(!tool.getVisualizing()) {
                onPressed();
              }
            },
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).indicatorColor,
                fontSize: 15
              ),
            ),
          ),
        );
      },
    );
  }
}