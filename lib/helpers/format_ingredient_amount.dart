import 'package:recipes/helpers/trim_trailing_zero.dart';

String formatIngredientAmount(double amount, int servings) {
  var total = amount * servings;

  var roundedToQuarter = (total * 4).roundToDouble() / 4;

  return trimTrailingZero(roundedToQuarter);
}
