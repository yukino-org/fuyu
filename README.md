<p align="center">
    <img src="https://github.com/yukino-org/media/blob/main/images/subbanners/gh-fuyu-banner.png?raw=true">
</p>

# Fuyu

🏂 A self-hostable rest api server for [Tenka](https://github.com/yukino-org/tenka-store).

By using this project, you agree to the [usage policy](https://yukino-org.github.io/wiki/tenka/disclaimer/).

[![License: GPL v3](https://img.shields.io/badge/License-GPL_v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Code Analysis](https://github.com/yukino-org/fuyu/actions/workflows/code-analysis.yml/badge.svg)](https://github.com/yukino-org/fuyu/actions/workflows/code-analysis.yml)

## Technology

-   [Dart](https://dart.dev/) (Language)
-   [Pub](https://pub.dev/) (Dependency Manager)
-   [Git](https://git-scm.com/) (Version Manager)

## Usage

```
<path/to/executable> --host <ip> --port <port> --modules <module1>[,<module2>,...]
```

Example:

```
fuyu --host 127.0.0.1 --port 8080 --modules zoro.to,mangadex.org
```

> The help command can be invoked by using the `help` command. Also the `/docs` route contains the api documentation.

## Code structure

-   [./cli](./cli) - Contains the local command-line tool.
-   [./src](./src) - Contains the source code of the server.
-   [./test](./test) - Contains unit tests.

## License

[![GPL-3.0](https://github.com/yukino-org/media/blob/main/images/license-logo/gplv3.png?raw=true)](./LICENSE)
