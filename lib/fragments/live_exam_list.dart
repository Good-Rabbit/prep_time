import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/fragments/exam_card.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

class LiveExamList extends StatefulWidget {
  const LiveExamList({
    super.key,
  });

  @override
  State<LiveExamList> createState() => _LiveExamListState();
}

class _LiveExamListState extends State<LiveExamList> {
  checkExams() {
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          checkExams();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkExams();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<ExamProvider>().getExams() == null) {
      // TODO loading
      return const Placeholder();
    }
    return SizedBox(
      height: 275,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: context.read<ExamProvider>().getExams()!.map((e) {
          if (DateTime.now().isAfter(e.start.add(e.duration))) {
            return const SizedBox();
          }
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            splashColor: Theme.of(context).colorScheme.primary,
            child: ExamCard(exam: e),
            onTap: () {
              context.go('/exam/${e.id}');
            },
          );
        }).toList(),
      ),
    );
  }
}
