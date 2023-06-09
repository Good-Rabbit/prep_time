import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    ticker();
  }

  ticker() {
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
            ticker();
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
    return ElevatedButton.icon(
      label: Text(
        '${minutes < 10 ? "0$minutes" : minutes}:${seconds < 10 ? "0$seconds" : seconds}',
      ),
      onPressed: () async {
        context.go(
          '/test_taker',
          extra: await context
              .read<ExamProvider>()
              .getExamById(context.read<ExamProvider>().ongoingExamId!),
        );
      },
      style: const ButtonStyle(
        iconColor: MaterialStatePropertyAll(Colors.white),
        foregroundColor: MaterialStatePropertyAll(Colors.white),
        backgroundColor: MaterialStatePropertyAll(Colors.red),
      ),
      icon: const Icon(
        Icons.edit_rounded,
      ),
    );
  }
}
