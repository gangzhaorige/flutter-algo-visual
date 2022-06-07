import 'package:flutter/material.dart';
import 'package:path_visualizer/components/topbar/top_bar_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Colors.blue,
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => const TopBarMobile(),
      ),
    );
  }

}