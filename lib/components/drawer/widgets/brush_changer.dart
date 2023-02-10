import 'package:flutter/material.dart';
import 'package:path_visualizer/main.dart';
import 'package:path_visualizer/node/weight_painter.dart';
import 'package:provider/provider.dart';

import '../../../algorithm/algorithm.dart';
import '../../../node/coin_painter.dart';
import '../../../node/start_end_painter.dart';
import '../../../node/wall_painter.dart';
import '../drawer_child.dart';

const Map<Brush, String> brushName = <Brush,String>{
  Brush.start : 'Source',
  Brush.end : 'Destination',
  Brush.wall : 'Wall',
  Brush.weight : 'Obstacle / Weight',
  Brush.coin : 'Golden Coin'
};

final Map<Brush, CustomPainter> brushWidget = <Brush, CustomPainter>{
  Brush.start : StartPainter(
    unitSize: 20, fraction: 1
  ),
  Brush.end : EndPainter(
    unitSize: 20, fraction: 1
  ),
  Brush.weight : WeightPainter(
    unitSize: 20, fraction: 1
  ),
  Brush.wall : WallPainter(
    unitSize: 20, fraction: 1
  ),
  Brush.coin : CoinPainter(
    unitSize: 20, fraction: 1
  ),
};

class BrushSelected extends StatelessWidget {
  const BrushSelected({
    Key? key,
    required this.brush,
    required this.index,
  }) : super(key: key);

  final Brush brush;
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
            Provider.of<AlgoVisualizerTools>(context, listen: false).changeBrush(index);
            if(brush == Brush.coin) {
              Provider.of<AlgoVisualizerTools>(context, listen: false).setCoin(true);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(brushName[brush] as String),
                    const SizedBox(
                      width: 5,
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CustomPaint(
                          painter: brushWidget[brush],
                        ),
                      ),
                    ),
                  ],
                ),
                Selector<AlgoVisualizerTools, int>(
                  selector: (_, AlgoVisualizerTools model) => model.getSelectedBrush(),
                  builder: (BuildContext context, int selectedIndex, Widget? child) {
                    return Icon(
                      index == selectedIndex ? Icons.check : null,
                      color: Colors.blue,
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

class BrushChanger extends StatelessWidget {
  const BrushChanger({
    Key? key,
  }) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    return DrawerChild(
      icon: Icons.brush, 
      category: 'Brush',
      action: Selector<AlgoVisualizerTools, List<Brush>>(
        selector: (_, AlgoVisualizerTools model) => model.getBrushes(),
        builder: (BuildContext context, List<Brush> brush, Widget? child) {
          return Column(
            children: <Widget>[
              for(int i = 0; i < brush.length; i++) ...<Widget>[
                BrushSelected(
                  brush: brush[i],
                  index: i,
                ),
                if(i != brush.length - 1) ...<Widget>[
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
      child: Selector<AlgoVisualizerTools, Brush>(
        selector: (_, AlgoVisualizerTools model) => model.getCurBrush(),
        builder: (BuildContext context, Brush curBrush, Widget? child) {
          return Text(
            '${brushName[curBrush]}',
            style: const TextStyle(
              fontSize: 14
            ),
          );
        },
      ),
    );
  }
}