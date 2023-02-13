
import 'package:flutter/material.dart';
import 'package:path_visualizer/algorithm/algorithm.dart';
import 'package:path_visualizer/components/topbar/helper/pages/algorithm.dart';
import 'package:path_visualizer/components/topbar/helper/pages/brush.dart';
import 'package:path_visualizer/components/topbar/helper/pages/coin.dart';
import 'package:path_visualizer/components/topbar/helper/pages/direction.dart';
import 'package:path_visualizer/components/topbar/helper/pages/obstacle.dart';
import 'package:path_visualizer/components/topbar/helper/pages/speed.dart';
import 'package:path_visualizer/components/topbar/helper/pages/welcome.dart';
import 'package:path_visualizer/components/topbar/helper/pages/button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tuple/tuple.dart';

class Helper extends StatelessWidget {
  const Helper({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    if(Provider.of<AlgoVisualizerTools>(context, listen: false).getFirstTime()) {
      Provider.of<AlgoVisualizerTools>(context, listen: false).setFirstTime(false);
      Future<dynamic>.delayed(const Duration(milliseconds: 500)).then((_) => showAlert(context));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          showAlert(context);
        },
        child: Icon(
          Icons.info_outline_rounded,
          size: 30,
          color: color,
        ),
      ),
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

  final List<Widget> widgets = const [
    WelcomeHelper(),
    AlgorithmHelper(),
    SpeedHelper(),
    BrushHelper(),
    CoinHelper(),
    ObstacleHelper(),
    DirectionHelper(),
    ButtonNav(),
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
            fit: BoxFit.contain,
            child: Center(
              child: Container(
                height: 450,
                width: sizingInformation.isMobile ? width * 0.86 : 450,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
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
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Skip'),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Provider.of<InformationModel>(context, listen: false).prev();
                              },
                              child: const Text('Previous'),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<InformationModel>(context, listen: false).next();
                              },
                              child: const Text('Next'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
