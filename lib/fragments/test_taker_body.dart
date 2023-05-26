import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/fragments/mcq.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

import '../data/exam.dart';

class TestTakerBody extends StatefulWidget {
  const TestTakerBody({
    super.key,
    required this.questions,
    required this.correctAnswers,
    required this.exam,
  });

  final List<Question> questions;
  final List<String> correctAnswers;
  final Exam exam;

  @override
  State<TestTakerBody> createState() => _TestTakerBodyState();
}

class _TestTakerBodyState extends State<TestTakerBody> {
  List<McqQuestion>? mcqQuestions;
  List<String> selectedAnswers = [];
  int selected = 1;
  int marks = 0;

  @override
  void initState() {
    super.initState();
    // * Initialize with empty answers
    for (var _ in widget.questions) {
      selectedAnswers.add('');
    }

    if (context.read<ExamProvider>().answers.isEmpty) {
      context.read<ExamProvider>().setOngoingExamAnswers(selectedAnswers);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<ExamProvider>().isExamOngoing) {
      int questionCount = 0;
      // * Show exam page while exam is ongoing
      mcqQuestions = widget.questions.map(
        (e) {
          return McqQuestion(
            question: e,
            count: questionCount++,
            onSelect: (value) {
              selectedAnswers[value.$1] = e.options[value.$2];
              context
                  .read<ExamProvider>()
                  .setOngoingExamAnswers(selectedAnswers);
            },
          );
        },
      ).toList();
      return testTakerPageFrame(
        context,
        Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.questions.length,
                itemBuilder: (context, i) {
                  int index = i + 1;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selected = index;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 50,
                        height: 40,
                        color: selected == index
                            ? Theme.of(context).highlightColor
                            : Theme.of(context).indicatorColor,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              index.toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            mcqQuestions![selected - 1],
          ],
        ),
      );
    } else {
      // * Show result once exam is set to over
      for (int i = 0; i < widget.correctAnswers.length; i++) {
        if (selectedAnswers[i] == widget.correctAnswers[i]) {
          marks++;
        }
      }
      return testTakerPageFrame(
        context,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Obtained marks:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                marks.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      );
    }
  }

  Scaffold testTakerPageFrame(BuildContext context, Widget child) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            context.go('/exam/${widget.exam.id}');
          },
        ),
        title: Text(
          selected.toString(),
        ),
        centerTitle: true,
      ),
      body: child,
    );
  }
}
