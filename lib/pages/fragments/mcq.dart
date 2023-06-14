import 'package:flutter/material.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/functions/dynamic_padding_determiner.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:provider/provider.dart';

class McqQuestion extends StatefulWidget {
  final Question question;
  final int count;
  final ValueChanged<(int, int)> onSelect;
  final bool complete;
  final int? selected;

  const McqQuestion({
    super.key,
    required this.question,
    required this.count,
    required this.onSelect,
    required this.complete,
    required this.selected,
  });

  @override
  State<McqQuestion> createState() => _McqQuestionState();
}

class _McqQuestionState extends State<McqQuestion> {
  int selected = 100;

  @override
  Widget build(BuildContext context) {
    // ! Handle empty error for a limited time frame
    if (context.watch<ExamProvider>().answers.isEmpty &&
        widget.selected == null) {
      return const CircularProgressIndicator();
    } else if (context.read<ExamProvider>().answers.isNotEmpty) {
      selected = context.watch<ExamProvider>().answers[widget.count];
    }

    bool gotIt = false;
    if (widget.selected != null) {
      gotIt = widget.selected == widget.question.correctIndex;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getDynamicPadding(context), vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.complete)
            ListTile(
              tileColor: gotIt ? Colors.green : Colors.red,
              textColor: Colors.white,
              iconColor: Colors.white,
              title: Text(gotIt ? 'Correct' : 'Wrong'),
              leading: Icon(gotIt ? Icons.check_rounded : Icons.close_rounded),
            ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.question.question,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: widget.question.options.map((op) {
                int e = widget.question.options.indexOf(op);
                if (widget.complete) {
                  bool isSelected = e == widget.selected;
                  bool isCorrect = e == widget.question.correctIndex;
                  Color? tileColor;
                  if (isCorrect) {
                    tileColor = Colors.green;
                  } else if (isSelected) {
                    tileColor = Colors.red;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: RadioMenuButton(
                        style: ButtonStyle(
                          iconColor: MaterialStatePropertyAll(
                            isSelected || isCorrect
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          foregroundColor: MaterialStatePropertyAll(
                            isSelected || isCorrect
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          backgroundColor: MaterialStatePropertyAll(tileColor),
                        ),
                        value: e,
                        groupValue: widget.selected ?? selected,
                        onChanged: widget.complete
                            ? (_) {}
                            : (value) => setState(
                                  () {
                                    selected = value as int;
                                    widget.onSelect((
                                      widget.count,
                                      value,
                                    ));
                                  },
                                ),
                        child: Text(
                          widget.question.options[e],
                        ),
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    title: RadioMenuButton(
                      value: e,
                      groupValue: selected,
                      onChanged: (value) => setState(
                        () {
                          selected = value ?? 100;
                          widget.onSelect((
                            widget.count,
                            value!,
                          ));
                        },
                      ),
                      child: Text(
                        widget.question.options[e],
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
