import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/router.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';

final RouteFactory animeSearch =
    createRouteFactory((final Router router) async {
  router.get(
    '/anime/search',
    (final Request request) async {
      final String? terms = request.url.queryParameters['terms'];
      if (terms == null) {
        return ResponseUtils.missingQuery('terms');
      }

      final dynamic parsedQuery = await TenkaQuery.parse<AnimeExtractor>(
        request: request,
        type: TenkaType.anime,
      );

      if (parsedQuery is Response) return parsedQuery;

      final TenkaQuery<AnimeExtractor> castedQuery =
          parsedQuery as TenkaQuery<AnimeExtractor>;

      try {
        final List<SearchInfo> results =
            await castedQuery.extractor.search(terms, castedQuery.locale);

        return Response.ok(
          JsonResponse.success(
            results.map((final SearchInfo x) => x.toJson()).toList(),
          ),
        );
      } catch (err) {
        return Response.internalServerError(
          body: JsonResponse.fail('Something went wrong'),
        );
      }
    },
  );
});
