import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/router.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';

final RouteFactory animeInfo = createRouteFactory((final Router router) async {
  router.get(
    '/anime/info',
    (final Request request) async {
      final String? url = request.url.queryParameters['url'];
      if (url == null) {
        return ResponseUtils.missingQuery('url');
      }

      final dynamic parsedQuery = await TenkaQuery.parse<AnimeExtractor>(
        request: request,
        type: TenkaType.anime,
      );

      if (parsedQuery is Response) return parsedQuery;

      final TenkaQuery<AnimeExtractor> castedQuery =
          parsedQuery as TenkaQuery<AnimeExtractor>;

      try {
        final AnimeInfo result =
            await castedQuery.extractor.getInfo(url, castedQuery.locale);

        return Response.ok(JsonResponse.success(result.toJson()));
      } catch (err) {
        return Response.internalServerError(
          body: JsonResponse.fail('Something went wrong'),
        );
      }
    },
  );
});
