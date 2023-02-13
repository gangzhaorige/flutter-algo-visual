import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/drawer.dart';

class ToolWidgets extends StatelessWidget {
  const ToolWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 45,
          automaticallyImplyLeading: false,
          title: const Text(
            'Path Finder',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        for(Widget widget in drawerWidget) ...<Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: [
                widget,
                Divider(
                  thickness: 1,
                  color: Theme.of(context).primaryColorLight,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}