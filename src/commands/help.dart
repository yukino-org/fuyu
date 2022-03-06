import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:args/src/help_command.dart' as args;
import '../config/meta.dart';
import '../core/args.dart' as app_args;

class HelpCommand extends args.HelpCommand<void> {
  @override
  String get invocation => '${runner.executableName} [arguments]';

  @override
  ArgParser get argParser => app_args.argParser;

  @override
  CommandRunner<void> get runner => CommandRunner<void>(AppMeta.id, '');

  static HelpCommand instance = HelpCommand();

  static bool isHelpCommand(final List<String> args) =>
      args.length == 1 && <String>['-h', '--help', 'help'].contains(args.first);
}
