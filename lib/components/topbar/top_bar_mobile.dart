import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../algorithm/algorithm.dart';
import 'helper/helper.dart';

class TopBarMobile extends StatelessWidget {
  const TopBarMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        Selector<AlgoVisualizerTools, Algorithm>(
          selector: (_, AlgoVisualizerTools model) => model.getAlgorithm(),
          builder: (BuildContext context, Algorithm algo, Widget? child) {
            return Text(
              '${algoName[algo]} Algorithm',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          }
        ),
        Helper(
          color: Colors.white,
        ),
      ],
    );
  }
}
