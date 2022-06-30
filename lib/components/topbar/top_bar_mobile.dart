import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/brush_changer.dart';
import 'package:path_visualizer/components/drawer/widgets/coin_switcher.dart';
import 'package:path_visualizer/components/drawer/widgets/speed_changer.dart';
import 'package:path_visualizer/node/coin_painter.dart';
import 'package:path_visualizer/node/start_end_painter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
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

  PageController controller = PageController();

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
      title: 'Pick An Algorithm.',
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
      title: 'Render Speed.',
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
      title: 'Brush.',
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
      title: 'Golden Coin Switcher.',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Switch between On and Off.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Determine if the coin should be collected before reaching the destination.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          CoinSwitcher(),
        ],
      ),
    ),
    InformationChildWidget(
      title: 'Adding Walls and Weights',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Choose a brush to start painting! Click on the grid to paint the grid with the choosen brush.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'You cannot go through walls, but you can go through the weights at the cost of 5.\n Note: Only Dijkstra and A* supports weight.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            'assets/gif/guide.gif',
          ),
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
      controller.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.linear);
    }
  }

  void prev() {
    if(index == 0) {
      return;
    } else {
      index--;
      controller.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.linear);
    }
  }
}

class InformationHelper extends StatelessWidget {
  const InformationHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        double width = MediaQuery.of(context).size.width;
        return Center(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Center(
              child: Container(
                height: 400,
                width: sizingInformation.isMobile ? width * 0.86 : 450,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Selector<InformationModel, Tuple2<List<Widget>, PageController>>(
                        selector: (_, InformationModel model) => Tuple2<List<Widget>, PageController>(model.widgets, model.controller),
                        builder: (BuildContext context, Tuple2<List<Widget>, PageController> tuple2, Widget? child) {
                          List<Widget> widgets = tuple2.item1;
                          PageController controller = tuple2.item2;
                          return PageView(
                            controller: controller,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              for(Widget widget in widgets) ...[
                                widget,
                              ]
                            ],
                          );
                        },
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
            ),
          ),
        );
      },
    );
  }
}
