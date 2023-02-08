import 'package:flutter/material.dart';
import 'package:path_visualizer/algorithm/algorithm.dart';
import 'package:path_visualizer/components/drawer/widgets/tools.dart';
import 'package:path_visualizer/components/topbar/top_bar_mobile.dart';
import 'package:path_visualizer/grid/grid.dart';
import 'package:provider/provider.dart';

class HomeViewTablet extends StatelessWidget {
  const HomeViewTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.blue,
              ),
            )
          ),
          child: const ToolWidgets(),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 15,
                      width: 15,
                    ),
                    Selector<AlgoVisualizerTools, Algorithm>(
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
                    const Helper(
                      color: Colors.blue,
                    ),
                  ],
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