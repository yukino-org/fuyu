import 'tab_space.dart';

typedef SchemaDataTypeStringify = String Function(TabSpace);

class SchemaDataType {
  const SchemaDataType._(this._stringify);

  factory SchemaDataType.string() =>
      SchemaDataType._((final TabSpace tab) => 'String');

  factory SchemaDataType.number() =>
      SchemaDataType._((final TabSpace tab) => 'Number');

  factory SchemaDataType.boolean() =>
      SchemaDataType._((final TabSpace tab) => 'Boolean');

  factory SchemaDataType.map(final SchemaDataType value) => SchemaDataType._(
        (final TabSpace tab) =>
            'Map<${SchemaDataType.string().stringify()}, ${value.stringify(tab)}>',
      );

  factory SchemaDataType.array(final SchemaDataType value) => SchemaDataType._(
        (final TabSpace tab) => 'Array<${value.stringify(tab)}>',
      );

  factory SchemaDataType.struct(final Map<String, SchemaDataType> schema) =>
      SchemaDataType._(
        (final TabSpace tab) => <String>[
          '{',
          schema.entries
              .map(
                (final MapEntry<String, SchemaDataType> x) =>
                    '${tab.next()}${x.key}: ${x.value.stringify(tab.next())};',
              )
              .join('\n'),
          '$tab}'
        ].join('\n').trim(),
      );

  final SchemaDataTypeStringify _stringify;

  String stringify([final TabSpace tab = TabSpace.zero]) => _stringify(tab);

  SchemaDataType get asNullable =>
      SchemaDataType._((final TabSpace tab) => '${stringify(tab)}?');
}
