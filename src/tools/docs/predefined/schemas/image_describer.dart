import '../../datatype.dart';
import 'http_headers.dart';

final SchemaDataType imageDescriberSchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'url': SchemaDataType.string(),
  'headers': httpHeadersSchemaDataType,
});
