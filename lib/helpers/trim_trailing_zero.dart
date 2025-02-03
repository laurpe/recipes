String trimTrailingZero(double number) {
  String numberAsString = number.toString();
  return numberAsString.contains('.0')
      ? numberAsString.split('.0')[0]
      : numberAsString;
}
