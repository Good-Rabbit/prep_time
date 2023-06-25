import 'package:flutter/material.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/pages/fragments/participating_exam_card.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

class ExamDestination extends StatefulWidget {
  const ExamDestination({super.key});

  @override
  State<ExamDestination> createState() => _ExamDestinationState();
}

class _ExamDestinationState extends State<ExamDestination> {
  @override
  Widget build(BuildContext context) {
    if (context.watch<ExamProvider>().pastExams == null ||
        context.watch<AuthProvider>().getCurrentUser() == null) {
      if (context.watch<AuthProvider>().getCurrentUser() != null) {
        context.watch<ExamProvider>().retrieveRegisteredForExams();
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      children: [
        ...context.watch<ExamProvider>().pastExams!.map(
          (e) {
            return ParticipatingExamCard(examFragment: e);
          },
        ).toList(),
      ],
    );
  }
}
