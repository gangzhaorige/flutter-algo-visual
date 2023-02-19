import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../../../theme.dart';

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ThemeNotifier, bool>(
      selector: (_, ThemeNotifier theme) => theme.isLight(),
      builder: (BuildContext context, bool isLight, Widget? child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10,10,10,0),
          child: GestureDetector(
            onTap: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggle();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isLight ? FontAwesome.sun : FontAwesome.moon,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${isLight ? 'Light' : 'Dark' } Mode',
                    )
                  ],
                ),
                Switch(
                  value: isLight,
                  onChanged: (bool value) => Provider.of<ThemeNotifier>(context, listen: false).toggle(),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}