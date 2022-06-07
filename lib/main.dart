import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_visualizer/components/home/home_view.dart';
import 'package:statsfl/statsfl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugRepaintRainbowEnabled = true;
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ],
  ).then(
    (_) => runApp(
      StatsFl(
        child: const MyApp(),
      ),
    ),
  );
}

enum Brush {
  wall,
  weight,
  start,
  end,
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rebuilding entire App');
    return MaterialApp(
      home: Container(
        color: Colors.blue,
        child: const SafeArea(
          child: HomeView()
        ),
      ),
    );
  }
}

