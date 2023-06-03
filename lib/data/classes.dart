class Classes {
  Classes({
    required this.name,
    required this.number,
  });

  int number;
  String name;

  @override
  String toString() {
    return '$name,$number';
  }

  static Classes? fromString(String classes) {
    if (classes == '') {
      return null;
    }
    List<String> parts = classes.trim().split(',');
    return Classes(name: parts[0], number: int.parse(parts[1]));
  }
}

List<Classes> classes = [
  Classes(name: 'Six ', number: 6),
  Classes(name: 'Seven ', number: 7),
  Classes(name: 'Eight ', number: 8),
  Classes(name: 'Nine ', number: 9),
];
