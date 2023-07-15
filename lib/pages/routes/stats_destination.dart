import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/pages/fragments/empty.dart';
import 'package:preptime/pages/fragments/stats_card.dart';
import 'package:preptime/pages/login.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

class StatsDestination extends StatelessWidget {
  const StatsDestination({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().getCurrentUser() == null) {
      return const AuthDialog(shouldPopAutomatically: false);
    }
    if (context.watch<ExamProvider>().stats == null) {
      context.read<ExamProvider>().retrievePreviousExamStats();
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (context.watch<ExamProvider>().stats!.isNotEmpty) {
        return ListView(
          children: [
            ...context.read<ExamProvider>().stats!.map(
              (e) {
                return InkWell(
                  onTap: () {
                    context.push('/stats/per', extra: e);
                  },
                  child: StatsCard(stats: e),
                );
              },
            ).toList(),
          ],
        );
      } else {
        return const Empty();
      }
    }
  }
}
