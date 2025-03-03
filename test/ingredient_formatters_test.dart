import 'package:recipes/helpers/ingredient_formatters.dart';
import 'package:test/test.dart';

void main() {
  test('ingredient amount is rounded and formatted correctly', () {
    /// Rounded up
    expect(formatIngredientAmount(0.230000), '0,25');
    expect(formatIngredientAmount(0.420000), '0,5');
    expect(formatIngredientAmount(0.745000), '0,75');
    expect(formatIngredientAmount(0.895555), '1');

    /// Rounded down
    expect(formatIngredientAmount(0.322222), '0,25');
    expect(formatIngredientAmount(0.620000), '0,5');
    expect(formatIngredientAmount(0.769000), '0,75');
    expect(formatIngredientAmount(1.124000), '1');
  });
}
