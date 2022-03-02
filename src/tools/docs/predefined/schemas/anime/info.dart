import '../../../datatype.dart';
import '../image_describer.dart';
import 'episode/info.dart';

final SchemaDataType animeInfoSchemaDataType =
    SchemaDataType.struct(<String, SchemaDataType>{
  'title': SchemaDataType.string(),
  'url': SchemaDataType.string(),
  'episodes': SchemaDataType.array(episodeInfoSchemaDataType),
  'locale': SchemaDataType.string(),
  'availableLocales': SchemaDataType.array(SchemaDataType.string()),
  'thumbnail': imageDescriberSchemaDataType.asNullable,
});
