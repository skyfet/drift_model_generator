import 'package:drift/drift.dart';
import 'package:example/example_record.dart';
import 'package:example/models/entity.dart';
import 'package:example/models/user.dart';

part 'drift_db.g.dart';

const tables = [
  Users,
  Entities,
  ExampleTypes,
  ExampleRecords,
];

@DriftDatabase(tables: tables)
class ExampleDatabase extends _$ExampleDatabase {
  ExampleDatabase() : super(_connect());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
    );
  }
}

LazyDatabase _connect() {
  throw UnimplementedError();
}
