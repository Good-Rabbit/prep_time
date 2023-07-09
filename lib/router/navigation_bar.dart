import 'package:flutter/material.dart';
import 'package:preptime/functions/nav_label_translator.dart';

import 'destinations.dart';

class DisappearingNavigationBar extends StatelessWidget {
  const DisappearingNavigationBar({
    super.key,
    required this.selected,
    this.onDestinationSelected,
    required this.backgroundColor,
  });

  final int selected;
  final ValueChanged<int>? onDestinationSelected;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selected,
      onDestinationSelected: onDestinationSelected,
      surfaceTintColor: backgroundColor,
      destinations: destinations.map((e) {
        return NavigationDestination(
          icon: Icon(e.icon),
          label: getTranslation(e.label, context),
          tooltip: e.label,
        );
      }).toList(),
    );
  }
}
