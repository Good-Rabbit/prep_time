class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.questionIds,
    required this.start,
    required this.subjects,
    required this.topics,
    required this.duration,
  });

  final String id;
  final String title;
  final String description;
  final List<(String id, String subject, int classNo)> questionIds;
  final List<String> subjects;
  final List<String> topics;
  final DateTime start;
  final Duration duration;
}
