import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:path_visualizer/algorithm/algorithm.dart';
import 'package:path_visualizer/components/drawer/widgets/tools.dart';
import 'package:path_visualizer/components/topbar/helper/helper.dart';
import 'package:path_visualizer/components/topbar/top_bar_mobile.dart';
import 'package:path_visualizer/grid/grid.dart';
import 'package:path_visualizer/main.dart';
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
                      Selector<ThemeNotifier, bool>(
                        selector: (_, ThemeNotifier theme) => theme.isLight(),
                        builder: (BuildContext context, bool isLight, Widget? child) {
                          return Builder(
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Provider.of<ThemeNotifier>(context, listen: false).toggle();
                                  },
                                  child: Icon(
                                    isLight ? FontAwesome.sun : FontAwesome.moon,
                                    size: 30,
                                  ),
                                ),
                              );
                            }
                          );
                        }
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