import 'dart:convert';
import 'package:tenka/tenka.dart';
import '../../config/meta.dart';
import '../../core/app.dart';
import '../../core/tenka.dart';
import 'api.dart';

String getHtmlDocumentation(final ApiDocs docs) {
  final String title =
      _esc('${AppMeta.name} v${AppMeta.version} - Documentation');

  return '''
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" type="image/png" href="favicon.png" />
    <title>$title</title>

    <link href="https://fonts.googleapis.com/css2?family=DM+Mono&family=DM+Sans:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css">
  </head>

  <body>
    <main>
      <div class="container">
        <h1>$title</h1>
      </div>
      <hr>
      <div class="container">
        <div>
          <h2>Available Modules</h2>
          <ul>
            ${TenkaManager.repository.installed.values.map(
            (final TenkaMetadata x) =>
                '<li>${x.name} v${x.version} (<code>${x.name.toLowerCase()}</code>)</li>',
          ).join('\n')}
          </ul>          
        </div>

        <div id="endpoints">
          <h2>Endpoints</h1>
          <p>Base URL: <code>${AppManager.address.url}</code></p>
          <ul>
            ${docs.routes.map(
            (final ApiRoute x) =>
                '<li><a href="#${_headingToId(x.heading)}">${_esc(x.heading)}</a></li>',
          ).join('\n')}
          </ul>

          <p>
            Note: A success response has <code>success</code> as <code>true</code> and a failed response has <code>success</code> as <code>false</code>.
          </p>

          ${docs.routes.map(
            (final ApiRoute x) => '''
          <h3 id="${_headingToId(x.heading)}">${_esc(x.heading)}</h2>
          <p>${_md(_esc(x.descripton))}</p>
          <pre><code>${_esc(x.method.name.toUpperCase())} ${_esc(x.path)}</code></pre>

          <table class="u-full-width">
            <thead>
              <tr>
                <th>Key</th>
                <th>Datatype</th>
                <th>Description</th>
              </tr>
            </thead>
            <tbody>
              ${x.keys.map(
                      (final ApiRouteKey y) => '''
              <tr>
                <td><code>${_esc(y.name)}</code></td>
                <td><code>${_esc(y.datatype.stringify())}</code></td>
                <td>${_md(_esc(y.description))}</td>
              </tr>
  ''',
                    ).join('\n')}
            </tbody>
          </table>

          <p><b>Success Response</b></p>
          <pre><code>${_esc(x.successResponse.stringify())}</code></pre>

          <p><b>Fail Response</b></p>
          <pre><code>${_esc(x.failResponse.stringify())}</code></pre>

          <br>
  ''',
          ).join('\n')}
        </div>
      </div>
    </main>
  </body>

  <style>
    :root {
      --primary-color: #A20669;
      --text-color: #262626;
      --secondary-text-color: #424242;
      --code-color: #e6e6e6;
    }

    body {
      font-family: "DM Sans", sans-serif;
      color: var(--text-color);
    }

    main {
      padding: 4rem 0;
    }

    pre, code {
      font-family: "DM Mono", monospace;
      background-color: var(--code-color);
      border: none !important;
      border-radius: 0.4rem;
    }

    a {
      color: var(--primary-color);
    }

    a:hover {
      color: var(--secondary-text-color);
    }
  </style>
</html>
''';
}

String _headingToId(final String heading) =>
    heading.toLowerCase().replaceAll(RegExp(r'[^A-z\d]'), '_');

String _esc(final String text) => htmlEscape.convert(text);

String _md(final String text) => text.replaceAllMapped(
      RegExp('`([^`]+)`'),
      (final Match match) => '<code>${match.group(1)}</code>',
    );
