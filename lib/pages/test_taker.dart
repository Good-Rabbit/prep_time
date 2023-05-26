import 'package:flutter/material.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

import '../fragments/test_taker_body.dart';

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
            List<String> correctAnswers = [];

            // TODO implement encryption
            for (Question question in snapshot.data!) {
              correctAnswers.add(question.options[question.correctIndex]);
            }
            List<String> answers = [];
            if (context.read<ExamProvider>().answers.isEmpty) {
              for (var _ in snapshot.data!) {
                answers.add('');
              }
            } else {
              answers = context.read<ExamProvider>().answers;
            }
            return TestTakerBody(
              questions: snapshot.data!,
              correctAnswers: correctAnswers,
              exam: exam,
            );
          } else {
            return const Scaffold(
              body: Text('No data'),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Text('Loading'),
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
