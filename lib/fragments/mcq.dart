import 'package:flutter/material.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/functions/dynamic_padding_determiner.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

class McqQuestion extends StatefulWidget {
  final Question question;
  final int count;
  final ValueChanged<(int, int)> onSelect;

  const McqQuestion({
    super.key,
    required this.question,
    required this.count,
    required this.onSelect,
  });

  @override
  State<McqQuestion> createState() => _McqQuestionState();
}

class _McqQuestionState extends State<McqQuestion> {
  String selected = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ! Handle empty error in marginal time frame
    if (context.watch<ExamProvider>().answers.isEmpty) {
      // TODO show loading
      return const Text('Loading');
    }
    selected = context.watch<ExamProvider>().answers[widget.count];

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getDynamicPadding(context), vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.content,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          ...widget.question.options.map(
            (option) {
              return Text(
                option,
                style: Theme.of(context).textTheme.bodyMedium,
              );
            },
          ).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SegmentedButton<String>(
                segments: widget.question.options
                    .map((e) => ButtonSegment<String>(value: e, label: Text(e)))
                    .toList(),
                selected: {selected},
                showSelectedIcon: false,
                onSelectionChanged: (p0) {
                  setState(() {
                    selected = p0.first;
                  });
                  widget.onSelect((
                    widget.count,
                    widget.question.options.indexOf(p0.first),
                  ));
                }),
          )
        ],
      ),
    );
  }
}
