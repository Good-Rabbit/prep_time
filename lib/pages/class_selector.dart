import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:preptime/data/classes.dart';
import 'package:preptime/functions/dynamic_padding_determiner.dart';
import 'package:preptime/services/intl.dart';
import 'package:preptime/services/settings_provider.dart';
import 'package:preptime/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class ClassSelector extends StatefulWidget {
  const ClassSelector({super.key});

  @override
  State<ClassSelector> createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<ClassSelector> {
  Classes selectedClass = classes.first;

  @override
  void initState() {
    super.initState();
    selectedClass =
        context.read<SettingsProvider>().getSelectedClass() ?? classes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings(context).changeClass),
        backgroundColor: themeColorWithAlpha,
        leading: const Icon(Icons.class_rounded),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 8.0, horizontal: getDynamicPadding(context)),
        child: Column(
          children: [
            ...classes
                .map((e) => RadioMenuButton(
                      value: e,
                      groupValue: selectedClass,
                      onChanged: (value) => setState(
                        () {
                          selectedClass = value as Classes;
                        },
                      ),
                      child: Text(
                        e.name,
                      ),
                    ))
                .toList(),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<SettingsProvider>()
                      .setSelectedClass(selectedClass);
                  Restart.restartApp(
                      webOrigin: kIsWeb ? Uri.base.origin.toString() : null);
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
