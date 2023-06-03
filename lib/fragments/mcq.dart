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
  Widget build(BuildContext context) {
    // ! Handle empty error for a limited time frame
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: widget.question.options
                  .map((e) => RadioMenuButton(
                        value: e,
                        groupValue: selected,
                        onChanged: (value) => setState(
                          () {
                            selected = value ?? '';
                            widget.onSelect((
                              widget.count,
                              widget.question.options.indexOf(value!),
                            ));
                          },
                        ),
                        child: Text(
                          e,
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
