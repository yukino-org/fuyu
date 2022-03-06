import 'package:dl/dl.dart';
import 'package:shelf/shelf.dart';
import '../core/app.dart';
import '../core/router.dart';
import '../tools/docs/api.dart';
import '../tools/logger.dart';
import '../tools/response.dart';

final RouteFactory proxy =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  if (AppManager.argResults['proxy'] as bool) {
    router.get(
      '/proxy',
      (final Request request) async {
        final Uri? uri = request.url.queryParameters['url'] != null
            ? Uri.tryParse(
                Uri.decodeComponent(request.url.queryParameters['url']!),
              )
            : null;
        if (uri == null) {
          return ResponseUtils.missingQuery('url');
        }

        try {
          final Downloader<DLProvider> downloader =
              Downloader<DLProvider>(provider: _getProvider(uri.toString()));

          final DLResponse dlResponse = await downloader.download(
            url: uri,
            headers: <String, String>{
              ...request.url.queryParameters,
              ...request.headers,
              'Host': uri.authority,
            },
          );

          return Response.ok(dlResponse.data);
        } catch (err) {
          Logger.error('response: Failed $err (${request.url}}');
          return Response.internalServerError(
            body: JsonResponse.somethingWentWrong,
          );
        }
      },
    );
  }
});

String getProxiedURL(final String url, final Map<String, String> headers) =>
    AppManager.argResults['proxy'] as bool
        ? AppManager.address.uri.replace(
            path: '/proxy',
            queryParameters: <String, String>{
              ...headers,
              'url': url,
            },
          ).toString()
        : '';

DLProvider _getProvider(final String url) {
  if (url.contains('.m3u8')) return const M3U8DLProvider();
  return const RawDLProvider();
}
