import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path_visualizer/algorithm/algorithm.dart';
import 'package:path_visualizer/components/bottom_nav/bottom_nav.dart';
import 'package:path_visualizer/components/topbar/top_bar.dart';
import 'package:path_visualizer/grid/grid.dart';
import 'package:provider/provider.dart';

class HomeViewMobile extends StatelessWidget {
  const HomeViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const TopBar(),
        Expanded(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: Center(
                  child: Selector<AlgoVisualizerTools, Algorithm>(
                    selector: (_, AlgoVisualizerTools model) => model.getAlgorithm(),
                    builder: (BuildContext context, Algorithm algo, Widget? child) {
                      return Text(
                        '${algoDescription[algo]}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }
                  ),
                ),
              ),
              const Expanded(
                child: GridWrapper(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}