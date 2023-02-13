import 'package:flutter/material.dart';
import 'package:path_visualizer/algorithm/algorithm.dart';
import 'package:path_visualizer/components/drawer/widgets/tools.dart';
import 'package:path_visualizer/components/topbar/helper/helper.dart';
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
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            )
          ),
          child: const ToolWidgets(),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 30,
                        width: 30,
                      ),
                      Flexible(
                        child: Selector<AlgoVisualizerTools, Algorithm>(
                          selector: (_, AlgoVisualizerTools model) => model.getAlgorithm(),
                          builder: (BuildContext context, Algorithm algo, Widget? child) {
                            return Text(
                              '${algoName[algo]}: ${algoDescription[algo]}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            );
                          }
                        ),
                      ),
                      Helper(
                        color: Theme.of(context).iconTheme.color!,
                      ),
                    ],
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