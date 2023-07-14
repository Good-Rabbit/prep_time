import 'package:flutter/material.dart';
import 'package:preptime/data/stats.dart';
import 'package:preptime/functions/number_translator.dart';
import 'package:preptime/functions/time_formatter.dart';
import 'package:preptime/services/intl.dart';

class StatsCard extends StatefulWidget {
  const StatsCard({super.key, required this.stats});

  final Stats stats;

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[700],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          strings(context).localeName == 'bn'
              ? 'Timestamp - ${translateEnglishNumbers(getFormattedTime(widget.stats.time))}'
              : 'Timestamp - ${getFormattedTime(widget.stats.time)}',
          style: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
