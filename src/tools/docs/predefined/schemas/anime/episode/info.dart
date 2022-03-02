import '../../../../datatype.dart';

final SchemaDataType episodeInfoSchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'episode': SchemaDataType.string(),
  'url': SchemaDataType.string(),
  'locale': SchemaDataType.string(),
});
