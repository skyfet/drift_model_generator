String makeSnake(String f) {
  return f
      .replaceAllMapped(
        RegExp(r'(?<=[a-z])[A-Z]'),
        (Match m) => '_${m.group(0)}',
      )
      .toLowerCase();
}
