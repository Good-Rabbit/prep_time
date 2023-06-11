import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/data/menu_items_enum.dart';
import 'package:preptime/functions/wide_screen_determiner.dart';
import 'package:preptime/pages/class_selector.dart';
import 'package:preptime/pages/fragments/live_ticker.dart';
import 'package:preptime/pages/fragments/popup_item_row.dart';
import 'package:preptime/pages/login.dart';
import 'package:preptime/router/navigation_bar.dart';
import 'package:preptime/router/navigation_rail.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/intl.dart';
import 'package:preptime/services/settings_provider.dart';
import 'package:provider/provider.dart';

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

    if (context.watch<SettingsProvider>().getSelectedClass() == null) {
      return const ClassSelector();
    }

    return Scaffold(
      // * Use the child provided by go_router
      appBar: AppBar(
              toolbarHeight: 60,
              title: Text(strings(context).appname),
              leading: const Icon(Icons.bookmark),
              actions: [
                if (context.watch<ExamProvider>().isExamOngoing)
                  const LiveTicker(),
                PopupMenuButton<MenuItems>(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            value: MenuItems.classChoice,
                            child: PopupItemRow(
                              icon: const Icon(Icons.class_rounded),
                              label: Text(
                                '${strings(context).classValue} - ${context.read<SettingsProvider>().getSelectedClass()!.name}',
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: MenuItems.localeChoice,
                            child: PopupItemRow(
                              icon: const Icon(Icons.language_rounded),
                              label: Text(
                                strings(context).language == 'বাংলা'
                                    ? 'English'
                                    : 'বাংলা',
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: MenuItems.themeChoice,
                            child: PopupItemRow(
                              icon: Icon(
                                context
                                            .read<SettingsProvider>()
                                            .getThemeMode() ==
                                        ThemeMode.dark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                              ),
                              label: Text(
                                context
                                            .read<SettingsProvider>()
                                            .getThemeMode() ==
                                        ThemeMode.dark
                                    ? strings(context).lightTheme
                                    : strings(context).darkTheme,
                              ),
                            ),
                          ),
                          if (context.read<AuthProvider>().getCurrentUser() ==
                              null)
                            PopupMenuItem(
                              value: MenuItems.loginChoice,
                              child: PopupItemRow(
                                icon: const Icon(
                                  Icons.login_rounded,
                                ),
                                label: Text(
                                  strings(context).login,
                                ),
                              ),
                            ),
                          if (context.read<AuthProvider>().getCurrentUser() !=
                              null)
                            PopupMenuItem(
                              value: MenuItems.logoutChoice,
                              child: PopupItemRow(
                                icon: const Icon(
                                  Icons.logout_rounded,
                                ),
                                label: Text(
                                  strings(context).logout,
                                ),
                              ),
                            ),
                        ],
                    onSelected: (value) => switch (value) {
                          MenuItems.classChoice =>
                            context.pushReplacement('/class_selector'),
                          MenuItems.localeChoice =>
                            context.read<SettingsProvider>().switchLocale(),
                          MenuItems.themeChoice =>
                            context.read<SettingsProvider>().swithThemeMode(),
                          MenuItems.loginChoice => showDialog(
                              context: context,
                              builder: (context) => const AuthDialog(
                                shouldPopAutomatically: true,
                              ),
                            ),
                          MenuItems.logoutChoice =>
                            context.read<AuthProvider>().signOut(),
                        },
                    iconSize: 25,
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Theme.of(context).iconTheme.color,
                    )),
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
