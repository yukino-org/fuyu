class TabSpace {
  const TabSpace(this.count);

  final int count;

  TabSpace next() => TabSpace(count + 1);
  TabSpace prev() => TabSpace(count - 1);

  @override
  String toString() => List<String>.filled(count, tab).join();

  static const String tab = '    ';

  static const TabSpace zero = TabSpace(0);
}
