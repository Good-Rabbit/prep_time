class Question {
  const Question({
    required this.id,
    required this.content,
    required this.options,
    required this.correctIndex,
    required this.difficulty,
    required this.time,
    this.topic,
  });

  final String id;
  final String content;
  final List<String> options;
  final int correctIndex;
  final int difficulty;
  final int time;
  final String? topic;
}
