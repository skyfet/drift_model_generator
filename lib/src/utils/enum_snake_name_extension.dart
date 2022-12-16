extension EnumSnakeName on Enum {
  String get snakeName => name
      .replaceAllMapped(
        RegExp(r'(?<=[a-z])[A-Z]'),
        (Match m) => '_${m.group(0)}',
      )
      .toLowerCase();
}
