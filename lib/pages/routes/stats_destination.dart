import 'package:flutter/material.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/pages/fragments/stats_card.dart';
import 'package:preptime/pages/login.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

class BoardDestination extends StatefulWidget {
  const BoardDestination({super.key});

  @override
  State<BoardDestination> createState() => _BoardDestinationState();
}

class _BoardDestinationState extends State<BoardDestination> {
  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().getCurrentUser() == null) {
      return const AuthDialog(shouldPopAutomatically: false);
    }
    if (context.watch<ExamProvider>().stats == null) {
      context.watch<ExamProvider>().retrievePreviousExamStats();
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      children: [
        ...context.watch<ExamProvider>().stats!.map(
          (e) {
            return StatsCard(stats: e);
          },
        ).toList(),
      ],
    );
  }
}
