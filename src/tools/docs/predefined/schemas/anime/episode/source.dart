import '../../../../datatype.dart';
import '../../http_headers.dart';

final SchemaDataType episodeSourceSchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'url': SchemaDataType.string(),
  'quality': SchemaDataType.string(),
  'headers': httpHeadersSchemaDataType,
  'locale': SchemaDataType.string(),
  'proxied_url': SchemaDataType.string(),
});
