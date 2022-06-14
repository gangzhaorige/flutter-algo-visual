import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../algorithm/algorithm.dart';
import '../home/home_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rebuilding AppDrawer');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (
                    BuildContext context,
                  ) => ChangeNotifierProvider<AlgoVisualizerTools>.value(
                    value: algo,
                    child: const SecondRoute(),
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const <Widget>[
                        Icon(
                          Icons.alarm,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Algorithm',
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Selector<AlgoVisualizerTools, Algorithm>(
                        selector: (_, AlgoVisualizerTools model) => model.curAlgorithm,
                        builder: (BuildContext context, Algorithm algo, Widget? child) {
                          return Text(
                            '${algoName[algo]}',
                            style: const TextStyle(
                              fontSize: 14
                            ),
                          );
                        }
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Change to BFS'),
            onTap: () {
              Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.bfs);
            },
          ),
          ListTile(
            title: const Text('Change to DFS'),
            onTap: () {
              Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.dfs);
            },
          ),
          ListTile(
            title: const Text('Change to BiBFS'),
            onTap: () {
              Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.biBfs);
            },
          ),
          ListTile(
            title: const Text('Change to Dijkstra'),
            onTap: () {
              Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.dijkstra);
            },
          ),
          ListTile(
            title: const Text('Change to A*'),
            onTap: () {
              Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.aStar);
            },
          ),
          Selector<AlgoVisualizerTools, double>(
            selector: (_, AlgoVisualizerTools model) => model.curSpeed,
            builder: (BuildContext context, double curSpeed, Widget? child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Slower'),
                        Text('Render Speed'),
                        Text('Faster'),
                      ],
                    ),
                  ),
                  Slider(
                    min: 15,
                    max: 45,
                    label: curSpeed.round().toString(),
                    onChanged: (double value) {
                      Provider.of<AlgoVisualizerTools>(context, listen: false).changeSpeed(value);
                    },
                    value: curSpeed,
                    divisions: 3,
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}