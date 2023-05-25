import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '404!',
          ),
          FilledButton(
            onPressed: () {
              context.go('/');
            },
            child: const Text('Go Home'),
          ),
        ],
      ),
    );
  }
}
