import 'package:flutter/material.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/pages/fragments/empty.dart';
import 'package:preptime/pages/fragments/participating_exam_card.dart';
import 'package:preptime/pages/login.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

class ExamDestination extends StatelessWidget {
  const ExamDestination({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().getCurrentUser() == null) {
      return const AuthDialog(shouldPopAutomatically: false);
    }
    if (context.watch<ExamProvider>().pastExams == null) {
      context.read<ExamProvider>().retrieveRegisteredForExams();
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (context.watch<ExamProvider>().pastExams!.isNotEmpty) {
        return ListView(
          children: [
            ...context.watch<ExamProvider>().pastExams!.map(
              (e) {
            return ParticipatingExamCard(examFragment: e);
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
