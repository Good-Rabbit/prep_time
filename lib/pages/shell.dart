import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/data/menu_items_enum.dart';
import 'package:preptime/fragments/popup_item_row.dart';
import 'package:preptime/functions/wide_screen_determiner.dart';
import 'package:preptime/pages/class_selector.dart';
import 'package:preptime/router/navigation_bar.dart';
import 'package:preptime/router/navigation_rail.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/intl.dart';
import 'package:preptime/services/settings_provider.dart';
import 'package:preptime/theme/theme.dart';
import 'package:provider/provider.dart';

import '../fragments/live_ticker.dart';
import '../router/destinations.dart';

// Shell widget for containing the destinations
class Shell extends StatefulWidget {
  const Shell({super.key, required this.child});

  final Widget child;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int selected = 0;
  bool isWide = false;

  @override
  Widget build(BuildContext context) {
    isWide = isWideScreen(context);

    if (context.watch<SettingsProvider>().selectedClass == null) {
      return const ClassSelector();
    }

    return Scaffold(
      // * Use the child provided by go_router
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(strings(context).appname),
        backgroundColor: themeColorWithAlpha,
        leading: const Icon(Icons.bookmark),
        actions: [
          if (context.watch<ExamProvider>().isExamOngoing) const LiveTicker(),
          // * User profile picture
          PopupMenuButton<MenuItems>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MenuItems.classChoice,
                child: PopupItemRow(
                  icon: const Icon(Icons.class_rounded),
                  label: Text(
                      '${strings(context).classValue} - ${context.read<SettingsProvider>().selectedClass!.name}'),
                ),
              ),
              PopupMenuItem(
                value: MenuItems.localeChoice,
                child: PopupItemRow(
                  icon: const Icon(Icons.language_rounded),
                  label: Text(
                    strings(context).language == 'বাংলা' ? 'English' : 'বাংলা',
                  ),
                ),
              ),
              PopupMenuItem(
                value: MenuItems.themeChoice,
                child: PopupItemRow(
                  icon: Icon(
                    context.read<SettingsProvider>().themeMode == ThemeMode.dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  label: Text(
                    context.read<SettingsProvider>().themeMode == ThemeMode.dark
                        ? strings(context).lightTheme
                        : strings(context).darkTheme,
                  ),
                ),
              ),
            ],
            onSelected: (value) => switch (value) {
              MenuItems.classChoice => context.pushReplacement('/class'),
              MenuItems.localeChoice =>
                context.read<SettingsProvider>().switchLocale(),
              MenuItems.themeChoice =>
                context.read<SettingsProvider>().swithThemeMode(),
            },
            icon: const Icon(Icons.face_2),
            iconSize: 25,
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Row(
        children: [
          // Build Navigation Rail for wide screens
          if (isWide)
            DisappearingNavigationRail(
              backgroundColor: Theme.of(context).colorScheme.background,
              selectedIndex: selected,
              onDestinationSelected: (value) => setState(() {
                selected = value;
                context.go(
                  destinations[selected].route,
                );
              }),
            ),
          Expanded(child: widget.child),
        ],
      ),
      // Build bottom navigation bar with predefined destinations for small screens
      bottomNavigationBar: isWide
          ? null
          : DisappearingNavigationBar(
              selected: selected,
              backgroundColor: Theme.of(context).colorScheme.background,
              onDestinationSelected: (value) => setState(() {
                selected = value;
                context.go(destinations[selected].route);
              }),
            ),
    );
  }
}
