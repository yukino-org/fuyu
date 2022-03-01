import '../config/meta.dart';

abstract class StatusCodes {
  static const int ok = 200;
  static const int notModified = 304;
  static const int badRequest = 400;
}

Map<String, String> getDefaultHeaders({
  final ContentType? contentType,
}) =>
    <String, String>{
      'Server': '${AppMeta.name}-beta',
      if (contentType != null) ...contentType.asJson,
    };

class ContentType {
  const ContentType(this.value);

  final String value;

  Map<String, String> get asJson => <String, String>{
        'Content-Type': value,
      };

  static const ContentType json = ContentType('application/json');
}
