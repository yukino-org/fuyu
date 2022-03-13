<p align="center">
    <img src="https://github.com/yukino-org/media/blob/main/images/subbanners/gh-fuyu-banner.png?raw=true">
</p>

# Fuyu

🏂 A self-hostable rest api server for [Tenka](https://github.com/yukino-org/tenka-store).

By using this project, you agree to the [usage policy](https://yukino-org.github.io/wiki/tenka/disclaimer/).

[![Version](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/yukino-org/fuyu/dist-data/badge-endpoint.json)](https://github.com/yukino-org/fuyu/)
[![Platforms](https://img.shields.io/static/v1?label=platforms&message=windows%20|%20linux%20|%20macos&color=lightgrey)](https://github.com/yukino-org/fuyu/)
[![License: GPL v3](https://img.shields.io/badge/License-GPL_v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Code Analysis](https://github.com/yukino-org/fuyu/actions/workflows/code-analysis.yml/badge.svg)](https://github.com/yukino-org/fuyu/actions/workflows/code-analysis.yml)
[![Build (Artifacts)](https://github.com/yukino-org/fuyu/actions/workflows/build-artifacts.yml/badge.svg)](https://github.com/yukino-org/fuyu/actions/workflows/build-artifacts.yml)
[![Release](https://github.com/yukino-org/fuyu/actions/workflows/release.yml/badge.svg)](https://github.com/yukino-org/fuyu/actions/workflows/release.yml)

## Installation

Pre-built binaries are released in `dist-*` branches. To use these, you need to have [git](https://git-scm.com/) installed.

### Clone this repository

For Windows:

```bash
git clone https://github.com/yukino-org/fuyu.git -b dist-windows
```

For Linux:

```bash
git clone https://github.com/yukino-org/fuyu.git -b dist-linux
```

For MacOS:

```bash
git clone https://github.com/yukino-org/fuyu.git -b dist-macos
```

### Usage

```bash
<path/to/executable> --host <ip> --port <port> --modules <module1>[,<module2>,...]
```

Example:

```bash
fuyu --host 127.0.0.1 --port 8080 --modules twist.moe,mangadex.org
```

> The help command can be invoked by using the `help` command. Also the `/docs` route contains the api documentation.

## Technology

-   [Dart](https://dart.dev/) (Language)
-   [Pub](https://pub.dev/) (Dependency Manager)
-   [Git](https://git-scm.com/) (Version Manager)

## Code structure

-   [./cli](./cli) - Contains the local command-line tool.
-   [./src](./src) - Contains the source code of the server.
-   [./test](./test) - Contains unit tests.

## Contributing

Ways to contribute to this project:

-   Submitting bugs and feature requests at [issues](https://github.com/yukino-org/fuyu/issues).
-   Opening [pull requests](https://github.com/yukino-org/fuyu/pulls) containing bug fixes, new features, etc.

## License

[![GPL-3.0](https://github.com/yukino-org/media/blob/main/images/license-logo/gplv3.png?raw=true)](./LICENSE)
