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
    return Card(
      color: themeColorWithAlpha,
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // * User Image
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                                if (loadingProgress == null) {
                                  return child;
                                }
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.read<AuthProvider>().getUsername() ??
                                'Guest',
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                              style: Theme.of(context).textTheme.bodySmall,
                            )
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
                        padding: EdgeInsets.all(5),
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
                  if (isWideScreen(context))
                    const SizedBox(
                      width: 5,
                    ),
                  // * User Rank
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.question_mark_rounded),
                          Text(
                            'Unranked',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // PopupMenuButton<MenuItems>(
                  //     itemBuilder: (context) => [
                  //           PopupMenuItem(
                  //             value: MenuItems.classChoice,
                  //             child: PopupItemRow(
                  //               icon: const Icon(Icons.class_rounded),
                  //               label: Text(
                  //                 '${strings(context).classValue} - ${context.read<SettingsProvider>().getSelectedClass()!.name}',
                  //               ),
                  //             ),
                  //           ),
                  //           PopupMenuItem(
                  //             value: MenuItems.localeChoice,
                  //             child: PopupItemRow(
                  //               icon: const Icon(Icons.language_rounded),
                  //               label: Text(
                  //                 strings(context).language == 'বাংলা'
                  //                     ? 'English'
                  //                     : 'বাংলা',
                  //               ),
                  //             ),
                  //           ),
                  //           PopupMenuItem(
                  //             value: MenuItems.themeChoice,
                  //             child: PopupItemRow(
                  //               icon: Icon(
                  //                 context
                  //                             .read<SettingsProvider>()
                  //                             .getThemeMode() ==
                  //                         ThemeMode.dark
                  //                     ? Icons.light_mode_rounded
                  //                     : Icons.dark_mode_rounded,
                  //               ),
                  //               label: Text(
                  //                 context
                  //                             .read<SettingsProvider>()
                  //                             .getThemeMode() ==
                  //                         ThemeMode.dark
                  //                     ? strings(context).lightTheme
                  //                     : strings(context).darkTheme,
                  //               ),
                  //             ),
                  //           ),
                  //           if (context.read<AuthProvider>().getCurrentUser() ==
                  //               null)
                  //             PopupMenuItem(
                  //               value: MenuItems.loginChoice,
                  //               child: PopupItemRow(
                  //                 icon: const Icon(
                  //                   Icons.login_rounded,
                  //                 ),
                  //                 label: Text(
                  //                   strings(context).login,
                  //                 ),
                  //               ),
                  //             ),
                  //           if (context.read<AuthProvider>().getCurrentUser() !=
                  //               null)
                  //             PopupMenuItem(
                  //               value: MenuItems.logoutChoice,
                  //               child: PopupItemRow(
                  //                 icon: const Icon(
                  //                   Icons.logout_rounded,
                  //                 ),
                  //                 label: Text(
                  //                   strings(context).logout,
                  //                 ),
                  //               ),
                  //             ),
                  //         ],
                  //     onSelected: (value) => switch (value) {
                  //           MenuItems.classChoice =>
                  //             context.pushReplacement('/class_selector'),
                  //           MenuItems.localeChoice =>
                  //             context.read<SettingsProvider>().switchLocale(),
                  //           MenuItems.themeChoice =>
                  //             context.read<SettingsProvider>().swithThemeMode(),
                  //           MenuItems.loginChoice => showDialog(
                  //               context: context,
                  //               builder: (context) => const AuthDialog(
                  //                 shouldPopAutomatically: true,
                  //               ),
                  //             ),
                  //           MenuItems.logoutChoice =>
                  //             context.read<AuthProvider>().signOut(),
                  //         },
                  //     iconSize: 25,
                  //     child: Icon(
                  //       Icons.more_vert_rounded,
                  //       color: Theme.of(context).iconTheme.color,
                  //     )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
