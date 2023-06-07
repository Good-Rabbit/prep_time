class Classes {
  Classes({
    required this.name,
    required this.key,
  });

  int key;
  String name;

  @override
  String toString() {
    return '$name,$key';
  }

  static Classes? fromString(String classes) {
    if (classes == '') {
      return null;
    }
    List<String> parts = classes.trim().split(',');
    return Classes(name: parts[0], key: int.parse(parts[1]));
  }
}

List<Classes> classes = [
  Classes(name: 'CC Admission', key: 1),
  Classes(name: 'Some Other Admission', key: 2),
  Classes(name: 'Die Nigga', key: 3),
];
