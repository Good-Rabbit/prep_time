import 'package:flutter/material.dart';
import 'package:preptime/functions/misc_label_translator.dart';

import 'destinations.dart';

class DisappearingNavigationRail extends StatefulWidget {
  const DisappearingNavigationRail({
    super.key,
    required this.backgroundColor,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final Color backgroundColor;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<DisappearingNavigationRail> createState() =>
      _DisappearingNavigationRailState();
}

class _DisappearingNavigationRailState
    extends State<DisappearingNavigationRail> {
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: isExtended,
      selectedIndex: widget.selectedIndex,
      backgroundColor: widget.backgroundColor,
      onDestinationSelected: widget.onDestinationSelected,
      leading: IconButton(
        onPressed: () {
          setState(() {
            isExtended = !isExtended;
          });
        },
        icon: const Icon(Icons.menu),
      ),
      groupAlignment: -.2,
      destinations: destinations.map((e) {
        return NavigationRailDestination(
          icon: Icon(e.icon),
          label: Text(getTranslation(e.label, context)),
        );
      }).toList(),
    );
  }
}
