import 'package:recipes/helpers/dot_to_comma.dart';

String trimTrailingZero(double number) {
  String numberWithComma = dotToComma(number);

  return numberWithComma.endsWith(",0")
      ? numberWithComma.substring(0, numberWithComma.length - 2)
      : numberWithComma;
}
