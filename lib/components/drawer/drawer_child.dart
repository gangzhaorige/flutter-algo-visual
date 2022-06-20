
import 'package:flutter/material.dart';

class DrawerChild extends StatelessWidget {
  const DrawerChild({
    Key? key,
    required this.icon,
    required this.category,
    required this.action,
    this.child,
  }) : super(key: key);

  final IconData icon;
  final String category;
  final Widget action;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if(child != null)...<Widget>[
                    child as Widget,
                  ],
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: action,
        ),
      ],
    );
  }
}