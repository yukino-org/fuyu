import '../../datatype.dart';

SchemaDataType getJsonResponse(final SchemaDataType data) =>
    SchemaDataType.struct(<String, SchemaDataType>{
      'success': SchemaDataType.boolean(),
      'data': data,
    });

SchemaDataType getFailJsonResponse() =>
    getJsonResponse(SchemaDataType.string());
