class Course {
  const Course({
    required this.title,
    required this.description,
    required this.subjects,
    required this.classes,
    required this.sampleExams,
    required this.published,
  });
  final String title;
  final String description;
  final List<String> subjects;
  final int classes;
  final int sampleExams;
  final DateTime published;
}
