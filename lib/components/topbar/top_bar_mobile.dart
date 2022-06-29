import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/brush_changer.dart';
import 'package:path_visualizer/components/drawer/widgets/coin_switcher.dart';
import 'package:path_visualizer/components/drawer/widgets/speed_changer.dart';
import 'package:path_visualizer/main.dart';
import 'package:path_visualizer/node/coin_painter.dart';
import 'package:path_visualizer/node/start_end_painter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../algorithm/algorithm.dart';
import '../drawer/widgets/algorithm_changer.dart';
import '../home/home_view.dart';

class TopBarMobile extends StatelessWidget {
  const TopBarMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<dynamic>.delayed(const Duration(milliseconds: 500)).then((_) => showAlert(context));
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
              showAlert(context);
            },
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => ChangeNotifierProvider<InformationModel>(
        create: (BuildContext context) => InformationModel(
          () => Navigator.pop(context),
        ),
        child: const InformationHelper(),
      ),
    );
  }
}

class InformationChildWidget extends StatelessWidget {
  const InformationChildWidget({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Center(
            child: content
          ),
        )
      ],
    );
  }

}

class InformationModel extends ChangeNotifier {

  int index = 0;

  List<InformationChildWidget> widgets = [
    InformationChildWidget(
      title: 'Welcome to Algorithm Visualizer',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'This short tutorial will walk you through all of the features of this application',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'If you want to dive right in, feel free to press the "Skip Tutorial" button below. Otherwise, press "Next"!',
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.pattern_sharp,
            size: 100,
          ),
        ],
      ),
    ),
    InformationChildWidget(
      title: 'Pick An Algorithm',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Choose an algorithm from the "Algorithms" section.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          AlgorithmChanger(),
        ],
      ),
    ),
    InformationChildWidget(
      title: 'Render Speed',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Slide between Slow and Fast',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'The faster it is the faster it renders the nodes. Gotta Go Fast!',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          SpeedChanger(),
        ],
      ),
    ),
    InformationChildWidget(
      title: 'Brush',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Choose a node type from the "Brush" section.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          BrushChanger(),
        ],
      ),
    ),
    InformationChildWidget(
      title: 'Golden Coin Switcher',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Switch between On and Off',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Determine if the coin should be collected before reaching the destination',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          Selector<AlgoVisualizerTools, bool>(
            selector: (_, AlgoVisualizerTools model) => model.hasCoin,
            builder: (BuildContext context, bool hasCoin, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CustomPaint(
                      painter: StartPainter(
                        fraction: 1,
                        unitSize: 30,
                      ),
                    )
                  ),
                  if(hasCoin) ...[
                    const Icon(
                      Icons.arrow_right
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CustomPaint(
                        painter: CoinPainter(
                          fraction: 1,
                          unitSize: 30,
                        ),
                      )
                    ),
                  ],
                  const Icon(
                    Icons.arrow_right
                  ),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CustomPaint(
                      painter: EndPainter(
                        fraction: 1,
                        unitSize: 30,
                      ),
                    )
                  ),
                ],
              );
            }
          ),
          const CoinSwitcher(),
        ],
      ),
    ),
  ];
  
  InformationModel(this.closeDialog);

  final Function closeDialog;

  void next() {
    if(index == widgets.length - 1) {
      closeDialog();
    } else {
      index++;
    }
    notifyListeners();
  }

  void prev() {
    if(index == 0) {
      index = widgets.length -1;
    } else {
      index--;
    }
    notifyListeners();
  }
}

class InformationHelper extends StatelessWidget {
  const InformationHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width * 0.86,
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              // this is the custom Widget showing everything
              child: Selector<InformationModel, Tuple2<int, List<Widget>>>(
                selector: (_, InformationModel model) => Tuple2<int, List<Widget>>(model.index, model.widgets),
                builder: (BuildContext context, Tuple2<int, List<Widget>> tuple2, Widget? child) {
                  List<Widget> widgets = tuple2.item2;
                  int index = tuple2.item1;
                  return widgets[index];
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Skip'),
                ),
                Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Provider.of<InformationModel>(context, listen: false).prev();
                      },
                      child: const Text('Previous'),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Provider.of<InformationModel>(context, listen: false).next();
                      },
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}

