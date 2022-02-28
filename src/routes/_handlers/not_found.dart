import 'package:shelf/shelf.dart';
import '../../tools/response.dart';

Future<Response> notFoundHandler(final Request request) async =>
    Response.notFound(JsonResponse.fail('Unknown route'));
