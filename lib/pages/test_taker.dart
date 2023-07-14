import 'package:flutter/material.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/firebase_provider.dart';
import 'package:provider/provider.dart';

import 'fragments/test_taker_body.dart';

class TestTakerShell extends StatelessWidget {
  const TestTakerShell({super.key,  this.exam, this.id});

  final Exam? exam;
  final String? id;

  @override
  Widget build(BuildContext context) {
    if (exam != null) {
      return FutureBuilder<List<Question>>(
        future: context.read<ExamProvider>().getExamQuestions(exam!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              for (Question question in snapshot.data!) {
                context
                    .read<ExamProvider>()
                    .correctAnswersIndexes
                    .add(question.correctIndex);
              }
              return TestTakerBody(
                questions: snapshot.data!,
                exam: exam!,
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
    } else {
      return FutureBuilder(
        future: FbProvider.rtdb!.ref('exams').child(id!).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // * If exam is found
            if (snapshot.data != null) {
              Exam exam = Exam.fromDataSnapshot(snapshot.data!)!;
              // * Show not ongoing for non ongoing exam page
              if (exam.id != context.read<ExamProvider>().ongoingExam?.id) {
                return const Text('This exam is not ongoing for you');
              }
              return FutureBuilder(
                future: context.read<ExamProvider>().getExamQuestions(exam),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null) {
                      for (Question question in snapshot.data!) {
                        context
                            .read<ExamProvider>()
                            .correctAnswersIndexes
                            .add(question.correctIndex);
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
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
            } else {
              return const Scaffold(
                body: Text('No exam with that ID'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          } else {
            return const Scaffold(
              body: Text('There was a problem with your connection'),
            );
          }
        },
      );
    }
  }
}
