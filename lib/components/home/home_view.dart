import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../algorithm/algorithm.dart';
import '../../grid/grid.dart';
import '../../main.dart';
import '../topbar/top_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double unitSize = (kIsWeb ? 30 : 25); 
    int rows = (MediaQuery.of(context).size.width / unitSize).round() - 1;
    int columns = (MediaQuery.of(context).size.height / unitSize * (kIsWeb ? 0.7 : 0.6)).round();
    AlgoVisualizerTools algo = AlgoVisualizerTools(
      rows: rows,
      columns: columns,
      unitSize: unitSize,
    );
    return ChangeNotifierProvider.value(
      builder: (context, child) {
        return Scaffold(
          drawerEnableOpenDragGesture: false,
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                // DrawerHeader(
                //   decoration: const BoxDecoration(
                //     color: Colors.blue,
                //   ),
                //   child: Selector<AlgoVisualizerTools, Algorithm>(
                //     selector: (_, model) => model.curAlgorithm,
                //     builder: (context, algo, child) {
                //       return Text('Cur algorithm: ${algo}');
                //     }
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                      value: algo,
                      child: SecondRoute(),
                    )));
                  },
                  child: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.alarm,
                                size: 40,
                              ),
                              Text(
                                'Algorithm',
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Selector<AlgoVisualizerTools, Algorithm>(
                              selector: (_, model) => model.curAlgorithm,
                              builder: (context, algo, child) {
                                return Text('$algo');
                              }
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 40,
                            )
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
          ),
          body: Column(
            children: [
              TopBar(),
              Expanded(
                child: Center(
                  child: ResponsiveWrapper(
                    child: GridWidget(
                      grid: Provider.of<AlgoVisualizerTools>(context, listen: false).grid,
                    )
                  ),
                ),
              ),
              // bottom bar
              Container(
                height: 55,
                color: Colors.blue,
                child: Center(
                  child: Builder(
                    builder: (context) {
                      print('rebuildin');
                      Grid grid = Provider.of<AlgoVisualizerTools>(context, listen: false).grid;
                      return MaterialButton(
                        onPressed: () {
                          grid.resetPath();
                          Algorithms algo = Algorithms(
                            columns: grid.columns,
                            endCol: grid.endCol,
                            endRow: grid.endRow,
                            nodes: grid.nodes,
                            rows: grid.rows,
                            startCol: grid.startCol,
                            startRow: grid.startRow
                          );
                          algo.visualizeAlgorithm(Provider.of<AlgoVisualizerTools>(context, listen: false).curAlgorithm);
                        },
                        child: const Text('Visualize'),
                      );
                    }
                  ),
                ),
              ),
            ],
          )
        );
      }, 
      value: algo,
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.dfs);
                Navigator.pop(context);
              },
              child: const Text('DFS'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                Provider.of<AlgoVisualizerTools>(context, listen: false).changeAlgorithm(Algorithm.bfs);
                Navigator.pop(context);
              },
              child: const Text('BFS'),
            ),
          ],
        )
      ),
    );
  }
}