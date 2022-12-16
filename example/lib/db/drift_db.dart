import 'package:drift/drift.dart';
import 'package:example/example.dart';
import 'package:example/example.drift.dart';

part 'drift_db.g.dart';

const tables = [
  AccountDetails,
  Entities,
  AccountTypes,
];

@DriftDatabase(tables: tables)
class ExampleDatabase extends _$ExampleDatabase {
  ExampleDatabase() : super(_connect());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
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
