class Answer {
  int selected;
  int timeTaken;
  int proficiencyIndex;
  List<String> topics;
  String subject;

  Answer({
    required this.selected,
    required this.topics,
    required this.subject,
    this.proficiencyIndex = 0,
    this.timeTaken = 100,
  });

  @override
  String toString() {
    String topicsString = '';
    for (var topic in topics) {
      topicsString += "$topic,";
    }
    topicsString.substring(0, (topicsString.length - 1));
    return "$selected:$timeTaken:$proficiencyIndex:$topicsString:$subject";
  }

  static Answer fromString(String string) {
    final parts = string.split(':');
    List<String> topics = parts[3].split(',');
    return Answer(
      selected: int.parse(parts[0]),
      timeTaken: int.parse(parts[1]),
      proficiencyIndex: int.parse(parts[2]),
      topics: topics,
      subject: parts[4],
    );
  }
}
