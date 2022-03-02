import '../../../datatype.dart';
import '../image_describer.dart';
import 'chapter/info.dart';

final SchemaDataType mangaInfoSchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'title': SchemaDataType.string(),
  'url': SchemaDataType.string(),
  'chapters': SchemaDataType.array(chapterInfoSchemaDataType),
  'locale': SchemaDataType.string(),
  'availableLocales': SchemaDataType.array(SchemaDataType.string()),
  'thumbnail': imageDescriberSchemaDataType.asNullable,
});
