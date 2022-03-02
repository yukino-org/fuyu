import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'http.dart';

enum JsonResponseState {
  success,
  fail,
}

class JsonResponse {
  const JsonResponse._({
    required this.state,
    required this.data,
  });

  final JsonResponseState state;
  final dynamic data;

  String get body => json.encode(<dynamic, dynamic>{
        'success': state == JsonResponseState.success,
        'data': data,
      });

  static String success(final dynamic data) => JsonResponse._(
        state: JsonResponseState.success,
        data: data,
      ).body;

  static String fail(final dynamic data) => JsonResponse._(
        state: JsonResponseState.fail,
        data: data,
      ).body;

  static String get somethingWentWrong => const JsonResponse._(
        state: JsonResponseState.fail,
        data: 'Something went wrong.',
      ).body;
}

abstract class ResponseUtils {
  static Response missingQuery(final String value) => Response(
        StatusCodes.badRequest,
        body: JsonResponse.fail('Missing query: $value'),
      );

  static Response invalidQuery(final String value) => Response(
        StatusCodes.badRequest,
        body: JsonResponse.fail('Invalid query: $value'),
      );
}
