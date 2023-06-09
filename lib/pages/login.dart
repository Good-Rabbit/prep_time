import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/functions/dynamic_padding_determiner.dart';
import 'package:preptime/functions/validate_email.dart';
import 'package:preptime/services/settings_provider.dart';
import 'package:provider/provider.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({
    super.key,
    required this.shouldPopAutomatically,
  });

  final bool shouldPopAutomatically;

  @override
  AuthDialogState createState() => AuthDialogState();
}

class AuthDialogState extends State<AuthDialog> {
  late TextEditingController textControllerEmail;
  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodeEmail;
  late FocusNode textFocusNodePassword;
  bool _isEditingEmail = false;
  bool _isRegistering = false;
  bool _isSigningIn = false;

  bool _isProcessing = false;

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerEmail.text = '';
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: getDynamicPadding(context)),
      child: Dialog(
        // ...
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Text(
                    'Login to access everything',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextField(
                  focusNode: textFocusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: textControllerEmail,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      _isEditingEmail = true;
                    });
                  },
                  onSubmitted: (value) {
                    textFocusNodeEmail.unfocus();
                    FocusScope.of(context).requestFocus(textFocusNodePassword);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: const Text('E-mail'),
                    errorText: _isEditingEmail
                        ? validateEmail(textControllerEmail.text)
                        : null,
                    errorStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  focusNode: textFocusNodePassword,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: textControllerPassword,
                  autofocus: false,
                  onSubmitted: (value) {
                    textFocusNodePassword.unfocus();
                    signIn();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: const Text('Password'),
                    errorText: _isEditingEmail
                        ? validateEmail(textControllerEmail.text)
                        : null,
                    errorStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: register,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: _isRegistering
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: signIn,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: _isSigningIn
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Log in',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          setState(() {
                            _isProcessing = true;
                          });
                          await context
                              .read<AuthProvider>()
                              .signInWithGoogle()
                              .then((result) {
                            log(result.toString());
                            if (result != null) {
                              if (widget.shouldPopAutomatically) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Couldn\'t log in'),
                                  content: const Text('Something went wrong.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Ok')),
                                  ],
                                ),
                              );
                            }
                          }).catchError((error) {
                            log('Registration Error: $error');
                          });
                          setState(() {
                            _isProcessing = false;
                          });
                        },
                        child: _isProcessing
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(),
                              )
                            : Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      context
                                                  .read<SettingsProvider>()
                                                  .getThemeMode() ==
                                              ThemeMode.dark
                                          ? 'assets/images/white-google-logo.png'
                                          : 'assets/images/black-google-logo.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const Text('Login with Google'),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signIn() async {
    setState(() {
      _isSigningIn = true;
    });
    await context
        .read<AuthProvider>()
        .signInWithEmailPassword(
            textControllerEmail.text, textControllerPassword.text)
        .then((result) {
      if (result != null) {
        if (widget.shouldPopAutomatically) {
          Navigator.of(context).pop();
        }
      }
    }).catchError((error) {
      log('Registration Error: $error');
    });

    setState(() {
      _isSigningIn = false;
    });
  }

  register() async {
    setState(() {
      _isRegistering = true;
    });
    await context
        .read<AuthProvider>()
        .registerWithEmailPassword(
            textControllerEmail.text, textControllerPassword.text)
        .then((result) {
      if (result == 'success') {
        if (widget.shouldPopAutomatically) {
          Navigator.of(context).pop();
        }
      }
    }).catchError((error) {
      log('Registration Error: $error');
    });

    setState(() {
      _isRegistering = false;
    });
  }
}
