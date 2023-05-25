import 'dart:async';

import 'package:flutter/material.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

class LiveTicker extends StatefulWidget {
  const LiveTicker({
    super.key,
  });

  @override
  State<LiveTicker> createState() => _LiveTickerState();
}

class _LiveTickerState extends State<LiveTicker> {
  Duration examTill = Duration.zero;

  @override
  void initState() {
    super.initState();
    liveTicker();
  }

  liveTicker() {
    Timer(const Duration(milliseconds: 999), () {
      if (mounted) {
        setState(() {
          examTill = (context.read<ExamProvider>().examTill ?? DateTime.now())
              .difference(
            DateTime.now(),
          );
          if (examTill.inSeconds <= 0) {
            return;
          } else {
              liveTicker();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    examTill =
        (context.read<ExamProvider>().examTill ?? DateTime.now()).difference(
      DateTime.now(),
    );
    int seconds = examTill.inSeconds % 60;
    int minutes = examTill.inSeconds ~/ 60;
    return FilledButton.icon(
      label: SizedBox(
          width: 40,
          child: Text(
              '${minutes < 10 ? "0$minutes" : minutes}:${seconds < 10 ? "0$seconds" : seconds}')),
      onPressed: () {
        context.read<ExamProvider>().completeOngoingExam();
        // context.go(
        //   '/test_taker',
        //   extra: ExamProvider.sampleExams[ExamProvider.sampleExams.indexWhere(
        //       (element) =>
        //           element.id == context.read<ExamProvider>().ongoingExamId)],
        // );
      },
      style: const ButtonStyle(
          iconColor: MaterialStatePropertyAll(Colors.white),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
          backgroundColor: MaterialStatePropertyAll(Colors.red)),
      icon: const Icon(
        Icons.edit_rounded,
      ),
    );
  }
}
