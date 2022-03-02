import 'datatype.dart';

enum ApiRouteMethod { get }

class ApiRouteKey {
  const ApiRouteKey({
    required this.name,
    required this.description,
    required this.datatype,
  });

  final String name;
  final String description;
  final SchemaDataType datatype;
}

class ApiRoute {
  const ApiRoute({
    required this.heading,
    required this.method,
    required this.path,
    required this.descripton,
    required this.successResponse,
    required this.failResponse,
    this.keys = const <ApiRouteKey>[],
  });

  final String heading;
  final ApiRouteMethod method;
  final String path;
  final String descripton;
  final List<ApiRouteKey> keys;
  final SchemaDataType successResponse;
  final SchemaDataType failResponse;
}

class ApiDocs {
  final List<ApiRoute> routes = <ApiRoute>[];

  void addRoute(final ApiRoute route) => routes.add(route);
}
