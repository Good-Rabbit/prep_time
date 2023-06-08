import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/functions/wide_screen_determiner.dart';
import 'package:preptime/pages/fragments/default_user_image.dart';
import 'package:preptime/services/settings_provider.dart';
import 'package:preptime/theme/theme.dart';
import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Card(
        color: themeColorWithAlpha,
        child: SizedBox(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // * User Image
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white),
                      padding: const EdgeInsets.all(3),
                      child: context.watch<AuthProvider>().getUserImageUrl() ==
                              null
                          ? const DefaultUserImage()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                context.read<AuthProvider>().getUserImageUrl()!,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  return const DefaultUserImage();
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  log('Failed to load image: ${error.toString()}');
                                  return const DefaultUserImage();
                                },
                              ),
                            ),
                    ),
                    // * User Name
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 205,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.read<AuthProvider>().getUsername() ??
                                  'Guest',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (context
                                    .read<SettingsProvider>()
                                    .getSelectedClass() !=
                                null)
                              Text(
                                  context
                                      .read<SettingsProvider>()
                                      .getSelectedClass()!
                                      .name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (isWideScreen(context))
                      // * Exam Counter
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text('Exams'),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    // * User Rank
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.question_mark_rounded),
                            Text('Unranked'),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
