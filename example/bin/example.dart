import 'package:example/example_record.dart';

void main(List<String> args) {
  final record = ExampleRecord(
    userId: 1,
    entityId: 1,
    number: 'number',
  );

  // Success
  final companion = record.toCompanion({'type'});
  print(companion);

  // Throws an error
  record.toCompanion({'isDefault'});
}
