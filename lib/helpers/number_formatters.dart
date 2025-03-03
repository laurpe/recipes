/// Replace dot with comma in a double and return it as a string.
String replaceDotWithComma(double number) {
  return number.toString().replaceAll('.', ',');
}

/// Remove trailing zero from a double and return it as a string.
String removeTrailingZero(double number) {
  String numberWithComma = replaceDotWithComma(number);

  return numberWithComma.endsWith(",0")
      ? numberWithComma.substring(0, numberWithComma.length - 2)
      : numberWithComma;
}

/// Round a double to the nearest quarter.
double roundToNearestQuarter(double amount) {
  return (amount * 4).roundToDouble() / 4;
}

/// Round a double to the nearest quarter and return it as a string.
String formatIngredientAmount(double amount) {
  var roundedValue = roundToNearestQuarter(amount);

  return removeTrailingZero(roundedValue);
}
