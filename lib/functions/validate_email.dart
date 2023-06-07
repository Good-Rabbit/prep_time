String? validateEmail(String value) {
  value = value.trim();

  if (value.isEmpty) {
    return 'Email can\'t be empty';
  } else if (!value.contains(RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
    return 'Enter a correct email address';
  }

  return null;
}
