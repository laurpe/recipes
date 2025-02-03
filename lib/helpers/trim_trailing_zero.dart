String trimTrailingZero(double number) {
  String numberAsString = number.toString();
  return numberAsString.endsWith(".0")
      ? numberAsString.substring(0, numberAsString.length - 2)
      : numberAsString;
}
