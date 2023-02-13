import 'package:flutter/material.dart';
import 'package:path_visualizer/components/drawer/widgets/coin_switcher.dart';
import 'package:path_visualizer/components/topbar/helper/helper.dart';

class CoinHelper extends StatelessWidget {
  const CoinHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return InformationChildWidget(
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
    );
  }
}