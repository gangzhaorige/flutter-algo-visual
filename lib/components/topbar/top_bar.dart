import 'package:flutter/material.dart';
import 'package:path_visualizer/components/topbar/top_bar_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      minWidth: 354,
      defaultScale: true,
      breakpoints: const <ResponsiveBreakpoint>[
        ResponsiveBreakpoint.resize(354, name: MOBILE),
      ],
      child: Container(
        height: 55,
        color: Theme.of(context).primaryColor,
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => const TopBarMobile(),
        ),
      ),
    );
  }
}