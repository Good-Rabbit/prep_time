import 'dart:async';

import 'package:flutter/material.dart';
import 'package:preptime/functions/time_formatter.dart';
import 'package:preptime/theme/theme.dart';

import '../data/exam.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.exam,
  });

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      exam.description,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Chip(
                    side: chipBorderOnColor,
                    label: Text(
                      exam.subjects[0],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (exam.subjects.length > 1)
                    Chip(
                      side: chipBorderOnColor,
                      label: Text(
                        exam.subjects[1],
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (exam.subjects.length > 2)
                    Chip(
                      side: chipBorderOnColor,
                      label: Text(
                        '+${(exam.subjects.length - 2).toString()}',
                      ),
                    ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (exam.start.isBefore(DateTime.now()))
                      const Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 17,
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (exam.start.isBefore(DateTime.now()))
                      OngoingTicker(
                        exam: exam,
                      ),
                    if (!exam.start.isBefore(DateTime.now()))
                      Text(
                        getFormattedTime(exam.start),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (!exam.start.isBefore(DateTime.now()))
                      Text(
                        '${exam.duration.inMinutes.toString()} minutes',
                        style: const TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OngoingTicker extends StatefulWidget {
  const OngoingTicker({
    super.key,
    required this.exam,
  });

  final Exam exam;

  @override
  State<OngoingTicker> createState() => _OngoingTickerState();
}

class _OngoingTickerState extends State<OngoingTicker> {
  Duration examTill = Duration.zero;
  DateTime examFrom = DateTime.now();

  @override
  void initState() {
    super.initState();
    examFrom = widget.exam.start.add(widget.exam.duration);
    ticker();
  }

  ticker() {
    Timer(const Duration(milliseconds: 999), () {
      if (mounted) {
        setState(() {
          examTill = examFrom.difference(
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
    examTill = examFrom.difference(
      DateTime.now(),
    );
    int seconds = examTill.inSeconds % 60;
    int minutes = examTill.inSeconds ~/ 60;
    return Chip(
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: Colors.red,
      side: const BorderSide(color: Colors.transparent),
      label: Text(
        'LIVE ${minutes < 10 ? "0$minutes" : minutes}:${seconds < 10 ? "0$seconds" : seconds}',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
