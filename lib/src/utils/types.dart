import 'package:analyzer/dart/element/type.dart';

const Map<String, DriftType> types = {
  'bool': DriftType('BoolColumn', 'boolean'),
  'String': DriftType('TextColumn', 'text'),
  'int': DriftType('IntColumn', 'integer'),
  'BigInt': DriftType('Int64Column', 'int64'),
  'double': DriftType('RealColumn', 'real'),
  'DateTime': DriftType('DateTimeColumn', 'dateTime'),
};

class DriftType {
  final String columnType;
  final String builderName;

  const DriftType(this.columnType, this.builderName);

  static DriftType fromDartType(DartType type) {
    return types[type.element!.name] ?? types['String']!;
  }
}
