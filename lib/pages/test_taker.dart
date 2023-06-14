import 'package:flutter/material.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

import 'fragments/test_taker_body.dart';

class TestTakerShell extends StatelessWidget {
  const TestTakerShell({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: context.read<ExamProvider>().getExamQuestions(exam),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            // TODO implement encryption
            for (Question question in snapshot.data!) {
              context.read<ExamProvider>().correctAnswers.add(question.correctIndex);
            }
            return TestTakerBody(
              questions: snapshot.data!,
              exam: exam,
            );
          } else {
            return const Scaffold(
              body: Text('No questions! There is a problem.'),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        } else {
          return const Scaffold(
            body: Text('There was a problem'),
          );
        }
      },
    );
  }
}
