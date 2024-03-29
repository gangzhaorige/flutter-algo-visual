import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../algorithm/algorithm.dart';
import '../drawer_child.dart';

class AlgoSelected extends StatelessWidget {
  const AlgoSelected({
    Key? key,
    required this.algo,
    required this.index,
  }) : super(key: key);

  final Algorithm algo;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () {
            Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(algoName[algo] as String),
                Selector<AlgoVisualizerTools, int>(
                  selector: (_, AlgoVisualizerTools model) => model.getSelectedAlgorithm(),
                  builder: (BuildContext context, int selectedIndex, Widget? child) {
                    return Icon(
                      index == selectedIndex ? Icons.check : null,
                      color: Theme.of(context).indicatorColor,
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlgorithmChanger extends StatelessWidget {
  const AlgorithmChanger({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return DrawerChild(
      icon: Icons.alarm,
      category: 'Algorithm',
      action: Selector<AlgoVisualizerTools, List<Algorithm>>(
        selector: (_, AlgoVisualizerTools model) => model.getAlgos(),
        builder: (BuildContext context, List<Algorithm> algo, Widget? child) {
          return Column(
            children: <Widget>[
              for(int i = 0; i < algo.length; i++) ...<Widget>[
                AlgoSelected(
                  algo: algo[i],
                  index: i,
                ),
                if(i != algo.length - 1) ...<Widget>[
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ]
            ],
          );
        }
      ),
      child: Selector<AlgoVisualizerTools, Algorithm>(
        selector: (_, AlgoVisualizerTools model) => model.getAlgorithm(),
        builder: (BuildContext context, Algorithm algo, Widget? child) {
          return Text(
            '${algoName[algo]}',
            style: const TextStyle(
              fontSize: 14
            ),
          );
        },
      ),
    );
  }
}