import '../../../../datatype.dart';

final SchemaDataType chapterInfoSchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'chapter': SchemaDataType.string(),
  'url': SchemaDataType.string(),
  'locale': SchemaDataType.string(),
  'title': SchemaDataType.string().asNullable,
  'volume': SchemaDataType.string().asNullable,
});
