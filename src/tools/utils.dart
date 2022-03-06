import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import 'package:utilx/locale.dart';
import '../core/tenka.dart';
import 'docs/api.dart';
import 'docs/datatype.dart';
import 'response.dart';

class TenkaQuery<T> {
  const TenkaQuery._({
    required this.type,
    required this.metadata,
    required this.extractor,
    required this.locale,
  });

  final TenkaType type;
  final TenkaMetadata metadata;
  final T extractor;
  final Locale locale;

  String getCacheKey(final String key) =>
      '${type.name}_${metadata.id}_${locale.toCodeString()}_$key';

  static Future<dynamic> parse<T>(final Request request) async {
    Locale? parsedLocale;
    if (request.url.queryParameters.containsKey(localeKey)) {
      final String rawLocale = request.url.queryParameters[localeKey]!;
      try {
        parsedLocale = Locale.parse(rawLocale);
      } catch (_) {
        return ResponseUtils.invalidQuery('$localeKey ($rawLocale)');
      }
    } else {}

    final String? moduleName = request.url.queryParameters[moduleKey];
    if (moduleName == null) {
      return ResponseUtils.missingQuery(moduleKey);
    }

    final TenkaMetadata? metadata = TenkaManager.repository
        .installed[TenkaManager.repository.storeNameIdMap[moduleName]];
    if (metadata == null) {
      return ResponseUtils.invalidQuery('$moduleKey ($moduleName)');
    }

    final T? extractor = await TenkaManager.getExtractor<T>(metadata);
    if (extractor == null) {
      return ResponseUtils.invalidQuery('$moduleKey ($moduleName)');
    }

    final TenkaType type;
    Locale locale;
    if (parsedLocale != null) {
      locale = parsedLocale;
    }

    if (extractor is AnimeExtractor) {
      type = TenkaType.anime;
      locale = extractor.defaultLocale;
    } else if (extractor is MangaExtractor) {
      type = TenkaType.manga;
      locale = extractor.defaultLocale;
    } else {
      return Response.internalServerError(
        body: 'Unable to find extractor kind.',
      );
    }

    return TenkaQuery<T>._(
      type: type,
      metadata: metadata,
      extractor: extractor,
      locale: locale,
    );
  }

  static const String moduleKey = 'module';
  static const String localeKey = 'locale';

  static String get parseQuery =>
      '$moduleKey={$moduleKey}&$localeKey={$localeKey}';

  static List<ApiRouteKey> get parseQueryKeys => <ApiRouteKey>[
        ApiRouteKey(
          name: moduleKey,
          description: 'Module Name.',
          datatype: SchemaDataType.string(),
        ),
        ApiRouteKey(
          name: localeKey,
          description: 'Locale Code. (eg: `en`, `en_us`)',
          datatype: SchemaDataType.string(),
        ),
      ];
}
