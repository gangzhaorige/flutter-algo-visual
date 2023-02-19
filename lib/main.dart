import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_visualizer/components/home/home_view.dart';
import 'package:path_visualizer/theme.dart';
import 'package:provider/provider.dart';

import 'algorithm/algorithm.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ],
  ).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AlgoVisualizerTools>(create: (BuildContext context) => AlgoVisualizerTools()),
          ChangeNotifierProvider<ThemeNotifier>(create: (BuildContext context) => ThemeNotifier(lightTheme)),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeNotifier>(context).getTheme(),
      title: 'Path Finder', 
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      home: Container(
        color: Theme.of(context).primaryColor,
        child: const SafeArea(
          child: HomeView()
        ),
      ),
    );
  }
}