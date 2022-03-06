import 'package:args/args.dart';

final ArgParser argParser = ArgParser()
  ..addOption('protocol', defaultsTo: 'http')
  ..addOption('host', mandatory: true)
  ..addOption('port', mandatory: true)
  ..addMultiOption(
    'modules',
    callback: (final List<String> value) {
      if (value.isEmpty) {
        throw const FormatException(
          'Option modules is must specify atleast one value',
        );
      }
    },
  )
  ..addFlag('suppress')
  ..addFlag('docs', defaultsTo: true)
  ..addFlag('proxy', defaultsTo: true)
  ..addFlag('listen', hide: true, defaultsTo: true);
