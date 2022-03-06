import '../../datatype.dart';
import 'http_headers.dart';

final SchemaDataType imageDescriberProxySchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'url': SchemaDataType.string(),
  'headers': httpHeadersSchemaDataType,
  'proxied_url': SchemaDataType.string(),
});
