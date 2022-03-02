import '../../../../datatype.dart';

final SchemaDataType pageInfoSchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'url': SchemaDataType.string(),
  'locale': SchemaDataType.string(),
});
