import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_visualizer/components/home/home_view.dart';
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
class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  bool _isLight = true;

  isLight() => _isLight;

  void toggle() async {
    if(_isLight) {
      _isLight = false;
      setTheme(darkTheme);
    } else {
      _isLight = true;
      setTheme(lightTheme);
    }
    notifyListeners();
  }

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}


final lightTheme = ThemeData(
  primaryColor: Colors.blue,
  primaryColorLight: Colors.blue,
  iconTheme: const IconThemeData(
    color: Colors.blue,
  ),
  // dividerColor: Colors.black,
  // brightness: Brightness.dark,
  // primarySwatch: Colors.teal,
  // canvasColor: const Color.fromARGB(255,41,45,62),
);

final darkTheme = ThemeData(
  primaryColor: const Color.fromARGB(255, 28,30,43),
  primaryColorLight: Colors.black,
  scaffoldBackgroundColor: const Color.fromARGB(255,41,45,62),
  dividerColor: Colors.black,
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  canvasColor: const Color.fromARGB(255,41,45,62),
);

