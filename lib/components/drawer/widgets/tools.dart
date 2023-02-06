import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/drawer.dart';

class ToolWidgets extends StatelessWidget {
  const ToolWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'Path Finder',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.blue,
              ),
              for(Widget widget in drawerWidget) ...<Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      widget,
                      const Divider(
                        thickness: 1,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}