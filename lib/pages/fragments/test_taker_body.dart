import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/data/answers.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/pages/fragments/mcq.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/stopwatch.dart';
import 'package:preptime/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/exam.dart';

class TestTakerBody extends StatefulWidget {
  const TestTakerBody({
    super.key,
    required this.questions,
    required this.exam,
  });

  final List<Question> questions;
  final Exam exam;

  @override
  State<TestTakerBody> createState() => _TestTakerBodyState();
}

class _TestTakerBodyState extends State<TestTakerBody> {
  List<McqQuestion>? mcqQuestions;
  List<Answer> selectedAnswers = [];
  int selected = 1;
  int marks = 0;
  List<StopWatch> stopwatches = [];

  initStopwatches() {
    for (var _ in widget.questions) {
      stopwatches.add(StopWatch());
    }
  }

  syncStopwatchWithStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < widget.questions.length; i++) {
      stopwatches[i].seconds =
          prefs.getInt(widget.questions[i].subject + widget.questions[i].id) ??
              0;
    }
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        prefs.setInt(
            widget.questions[selected - 1].subject +
                widget.questions[selected - 1].id,
            stopwatches[selected - 1].elapsedSeconds);
      }
    });
  }

  @override
  void initState() {
    initStopwatches();
    syncStopwatchWithStorage();
    // * Start the first stopwatch
    stopwatches[0].start();
    super.initState();
    // * Initialize with empty answers
    for (var q in widget.questions) {
      selectedAnswers.add(Answer(
        selected: 100,
        topics: q.topics,
        subject: q.subject,
        timeTaken: 100,
        proficiencyIndex: 0,
      ));
    }

    if (context.read<ExamProvider>().answers.isEmpty) {
      context.read<ExamProvider>().setOngoingExamAnswers(selectedAnswers);
    }
  }

  @override
  Widget build(BuildContext context) {
    int questionCount = 0;
    // * Show exam page while exam is ongoing
    mcqQuestions = [];
    for (var i = 0; i < widget.questions.length; i++) {
      mcqQuestions!.add(
        McqQuestion(
          question: widget.questions[i],
          complete: context.watch<ExamProvider>().isExamOngoing ? false : true,
          selected: context.watch<ExamProvider>().isExamOngoing
              ? null
              : selectedAnswers[i].selected,
          count: questionCount++,
          onSelect: (value) {
            selectedAnswers[value.$1].selected = value.$2;
            selectedAnswers[value.$1].timeTaken =
                stopwatches[selected - 1].elapsedSeconds;
            context.read<ExamProvider>().setOngoingExamAnswers(selectedAnswers);
          },
        ),
      );
    }
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
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      stopwatches[selected - 1].stop();
                      selected = index;
                      stopwatches[selected - 1].start();
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      width: 50,
                      height: 40,
                      color: selected == index
                          ? themeColorWithAlpha
                          : Theme.of(context).secondaryHeaderColor,
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
          mcqQuestions![(selected - 1)],
        ],
      ),
    );
  }

  Scaffold testTakerPageFrame(BuildContext context, Widget child) {
    // * Calculate results when exam is over
    if (!context.watch<ExamProvider>().isExamOngoing) {
      marks = 0;
      for (int i = 0;
          i < context.read<ExamProvider>().correctAnswersIndexes.length;
          i++) {
        if (selectedAnswers[i].selected ==
            context.read<ExamProvider>().correctAnswersIndexes[i]) {
          marks++;
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            context.go('/exam/${widget.exam.id}');
          },
        ),
        title: Text(
          context.watch<ExamProvider>().isExamOngoing
              ? selected.toString()
              : 'You got: $marks',
        ),
        centerTitle: true,
      ),
      body: child,
    );
  }
}
