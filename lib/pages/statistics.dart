import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/data/stats.dart';
import 'package:preptime/functions/number_translator.dart';
import 'package:preptime/functions/time_formatter.dart';
import 'package:preptime/services/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key, required this.stats});

  final Stats stats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            context.go('/stats');
          },
        ),
        title: Text(
          strings(context).localeName == 'bn'
              ? translateEnglishNumbers(getFormattedTime(stats.time).toString())
              : getFormattedTime(stats.time).toString(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Indicators',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 1,
                children: [
                  Container(
                    color: Colors.red[400],
                    child: const Center(
                      child: Text(
                        'Super Bad',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.orange[400],
                    child: const Center(
                      child: Text(
                        'Bad',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.yellow[400],
                    child: const Center(
                      child: Text(
                        'Somewhat',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.green[400],
                    child: const Center(
                      child: Text(
                        'Good',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.purple[400],
                    child: const Center(
                      child: Text(
                        'Too Good',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: stats.topicStats.length * 80 + 20,
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis:
                        NumericAxis(minimum: 0, maximum: 170, interval: 25),
                    series: <ChartSeries<TopicStat, String>>[
                      BarSeries<TopicStat, String>(
                        width: 0.7,
                        dataSource: stats.topicStats,
                        xValueMapper: (TopicStat data, _) {
                          return data.topic;
                        },
                        yValueMapper: (TopicStat data, _) {
                          if (data.proficiencyIndex > 170) {
                            data.proficiencyIndex = 170;
                          }
                          return data.proficiencyIndex;
                        },
                        name: 'Gold',
                        pointColorMapper: (datum, index) {
                          if (datum.proficiencyIndex < 40) {
                            return Colors.red[400];
                          } else if (datum.proficiencyIndex < 70) {
                            return Colors.orange[400];
                          } else if (datum.proficiencyIndex < 100) {
                            return Colors.yellow[400];
                          } else if (datum.proficiencyIndex < 120) {
                            return Colors.green[400];
                          } else {
                            return Colors.purple[400];
                          }
                        },
                        // dataLabelMapper: (datum, index) {
                        //   if (datum.proficiencyIndex < 40) {
                        //     return 'Super Bad';
                        //   } else if (datum.proficiencyIndex < 70) {
                        //     return 'Bad';
                        //   } else if (datum.proficiencyIndex < 100) {
                        //     return 'Somewhat';
                        //   } else if (datum.proficiencyIndex < 120) {
                        //     return 'Good';
                        //   } else {
                        //     return 'Too Good';
                        //   }
                        // },
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
