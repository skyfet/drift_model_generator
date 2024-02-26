library drift_model_generator;

import 'package:drift/drift.dart' show CustomSqlType, GenerationContext;

class TimestampType implements CustomSqlType<DateTime> {
  const TimestampType();

  @override
  String mapToSqlLiteral(DateTime dartValue) {
    return "'${dartValue.toIso8601String()}'";
  }

  @override
  Object mapToSqlParameter(DateTime dartValue) => dartValue.toIso8601String();

  @override
  DateTime read(Object fromSql) => DateTime.parse(fromSql.toString());

  @override
  String sqlTypeName(GenerationContext context) => 'timestamp';
}
