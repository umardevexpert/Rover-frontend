extension IntExtension on int {
  String get ordinalNumberSuffix {
    final absThis = abs();
    final isSecondDecade = absThis % 100 - absThis % 10 == 10; // it's 11th, 12th, 13th NOT 11st, 12nd, 13rd
    if (isSecondDecade) {
      return 'th';
    }
    switch (absThis % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String get asFormattedOrdinal => '$this$ordinalNumberSuffix';
}
