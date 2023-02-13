import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/brush_changer.dart';
import 'package:path_visualizer/components/topbar/helper/helper.dart';

class BrushHelper extends StatelessWidget {
  const BrushHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return InformationChildWidget(
      title: 'Brush.',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Choose a node type from the "Brush" section.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          BrushChanger(),
        ],
      ),
    );
  }
}