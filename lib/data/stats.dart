import 'package:cloud_firestore/cloud_firestore.dart';

class Stats {
  DateTime time;
  List<TopicStat> topicStats;

  Stats({
    required this.topicStats,
    required this.time,
  });

  static Stats fromDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    DateTime time = DateTime.parse(snapshot.id);
    List<TopicStat> topicStats = snapshot.data().entries.map((e) {
      return TopicStat(topic: e.key, proficiencyIndex: e.value);
    }).toList();
    return Stats(topicStats: topicStats, time: time);
  }
}

class TopicStat {
  String topic;
  int proficiencyIndex;

  TopicStat({
    required this.topic,
    required this.proficiencyIndex,
  });
}
