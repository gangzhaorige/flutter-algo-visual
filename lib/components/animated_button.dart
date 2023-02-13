import 'package:flutter/material.dart';
import 'package:path_visualizer/grid/grid.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../algorithm/algorithm.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({super.key, required this.grid});
  final Grid grid;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

enum ButtonState {init, loading, done}

class _AnimatedButtonState extends State<AnimatedButton> {
  ButtonState state = ButtonState.init;
  @override
  Widget build(BuildContext context) {
    bool isStreched = state == ButtonState.init;
    return Consumer<AlgoVisualizerTools>(
      builder: (BuildContext context, AlgoVisualizerTools tool, Widget? child) {
        return SizedBox(
          height: 50,
          child: isStreched ? buildOutlined(tool) : const VisualizingButton(),
        );
      },
    );
  }

  Widget buildOutlined(AlgoVisualizerTools tool) {
    return OutlinedButton(
      onPressed: () async {
        setState(() => state = ButtonState.loading);
        widget.grid.resetPathVisual();
        Algorithms algo = Algorithms(
          columns: widget.grid.columns,
          endCol: widget.grid.endCol,
          endRow: widget.grid.endRow,
          nodes: widget.grid.nodes,
          rows: widget.grid.rows,
          startCol: widget.grid.startCol,
          startRow: widget.grid.startRow,
          coinRow: widget.grid.coinRow,
          coinCol: widget.grid.coinCol,
          grid: widget.grid,
        );
        algo.visualizeAlgorithm(
          tool.getAlgorithm(),
          tool.getSpeed().toInt(),
          tool.toggleVisualizing,
          tool.getCoin(),
          tool.getIsDiagonal(),
          tool.setLengthPath,
        ).then((_) => {
          showAlert(context, tool.getLengthPath(), tool.getAlgorithm()).then((value) {
            setState(() => state = ButtonState.init);
          }),
          // setState(() => state = ButtonState.init),
          tool.setLengthPath(0),
        });
      },
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: BorderSide(width: 2, color: Theme.of(context).indicatorColor),
      ),
      child: FittedBox(
        child: Text(
          'V',
          style: TextStyle(
            color: Theme.of(context).indicatorColor,
          ),
        ),
      ),
    );
  }

  Future<void> showAlert(BuildContext context, int path, Algorithm curAlgorithm) async {
    String text = 'The ';
    if(curAlgorithm != Algorithm.dfs) {
      text += 'shortes ';
    }
    text += 'distance from source to target is $path.';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        bool isVisible = true;
        Future<dynamic>.delayed(const Duration(seconds: 3)).then((value) {
          if (isVisible) {
            Navigator.of(context).pop();
          }
        });
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  algoName[curAlgorithm]!,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(text),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    isVisible = false;
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class VisualizingButton extends StatelessWidget {
  const VisualizingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'V',
          style: TextStyle(
            color: Theme.of(context).indicatorColor,
          ),
        ),
        LoadingAnimationWidget.threeArchedCircle(
          color: Theme.of(context).indicatorColor,
          size: 50,
        ),
      ],
    );
  }
}