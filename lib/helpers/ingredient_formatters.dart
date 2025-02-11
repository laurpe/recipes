/// Replace dot with comma in a double number and return it as a string.
String replaceDotWithComma(double number) {
  return number.toString().replaceAll('.', ',');
}

/// Remove trailing zero from a double number and return it as a string.
String removeTrailingZero(double number) {
  String numberWithComma = replaceDotWithComma(number);

  return numberWithComma.endsWith(",0")
      ? numberWithComma.substring(0, numberWithComma.length - 2)
      : numberWithComma;
}

/// Round a double number to the nearest quarter.
double roundToNearestQuarter(double amount) {
  return (amount * 4).roundToDouble() / 4;
}

/// Round ingredient amount to the nearest quarter and return it as a string.
String formatIngredientAmount(double amount) {
  var roundedValue = roundToNearestQuarter(amount);

  return removeTrailingZero(roundedValue);
}
