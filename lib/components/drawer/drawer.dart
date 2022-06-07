import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../algorithm/algorithm.dart';
import '../home/home_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          size: 40,
                        ),
                        Text(
                          'Algorithm',
                          style: TextStyle(
                            fontSize: 20
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
                          return Text('$algo');
                        }
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 40,
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
        ],
      ),
    );
  }
}