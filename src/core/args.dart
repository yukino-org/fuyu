import 'package:args/args.dart';

final ArgParser argParser = ArgParser()
  ..addOption('host', mandatory: true)
  ..addOption('port', mandatory: true)
  ..addMultiOption('modules')
  ..addOption('defaultLocale')
  ..addFlag('suppress')
  ..addFlag('listen', hide: true, defaultsTo: true);
