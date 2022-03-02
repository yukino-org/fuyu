import '../../../datatype.dart';
import '../image_describer.dart';

final SchemaDataType searchInfoSchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'title': SchemaDataType.string(),
  'url': SchemaDataType.string(),
  'locale': SchemaDataType.string(),
  'thumbnail': imageDescriberSchemaDataType.asNullable,
});
