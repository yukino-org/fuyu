import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import 'package:utilx/utilities/locale.dart';
import '../core/tenka.dart';
import 'response.dart';

class TenkaQuery<T> {
  const TenkaQuery._({
    required this.type,
    required this.extractor,
    required this.locale,
  });

  final TenkaType type;
  final T extractor;
  final Locale locale;

  static Future<dynamic> parse<T>({
    required final Request request,
    required final TenkaType type,
  }) async {
    final Locale locale;

    if (request.url.queryParameters.containsKey('locale')) {
      final String rawLocale = request.url.queryParameters['locale']!;
      try {
        locale = Locale.parse(rawLocale);
      } catch (_) {
        return ResponseUtils.invalidQuery('locale ($rawLocale)');
      }
    } else {
      locale = TenkaManager.defaultLocale;
    }

    final String? moduleName = request.url.queryParameters['module'];
    if (moduleName == null) {
      return ResponseUtils.missingQuery('module');
    }

    final TenkaMetadata? metadata = TenkaManager.repository
        .installed[TenkaManager.repository.storeNameIdMap[moduleName]];
    if (metadata == null || metadata.type != type) {
      return ResponseUtils.invalidQuery('module ($moduleName)');
    }

    final T? extractor = await TenkaManager.getExtractor<T>(metadata);
    if (extractor == null) {
      return ResponseUtils.invalidQuery('module ($moduleName)');
    }

    return TenkaQuery<T>._(
      type: type,
      extractor: extractor,
      locale: locale,
    );
  }
}
