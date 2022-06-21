import 'package:flutter/material.dart';
import 'package:path_visualizer/main.dart';
import 'package:path_visualizer/node/node_model.dart';
import 'package:provider/provider.dart';
import '../../algorithm/algorithm.dart';
import '../home/home_view.dart';

class TopBarMobile extends StatelessWidget {
  const TopBarMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rebuilding TopBarMobile');
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
          selector: (_, AlgoVisualizerTools model) => model.getCurAlgorithm(),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              // Provider.of<AlgoVisualizerTools>(context, listen: false).changeBrush();
            },
            child: Selector<AlgoVisualizerTools, Brush>(
              selector: (_, AlgoVisualizerTools model) => model.getCurBrush(),
              builder: (BuildContext context, Brush brush, Widget? child) {
                return Icon(
                  Icons.palette_outlined,
                  color: brushColor[brush],
                  size: 30,
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}