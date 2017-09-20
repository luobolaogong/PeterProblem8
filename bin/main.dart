import 'dart:math';

main(List<String> arguments) {
  int minBase = 10;
  int maxBase = 10;
  int minNDigits = 4;
  int maxNDigits = 4;
  int minValue = 100;

  print("Starting at " + (new DateTime.now()).toString());
  Stopwatch stopWatch = new Stopwatch();

  for (int base = minBase; base <= maxBase; base++) {
    for (int nDigits = minNDigits; nDigits <= maxNDigits; nDigits++) {
      stopWatch.start();

      int maxValue = ((pow(base, nDigits)) / 2.0).ceil(); // Only need to go half way
      TedNumbers tedNumber = new TedNumbers(base, nDigits, minValue);
      for (int value = minValue; value <= maxValue; value++) {
        tedNumber.increment();
        if (tedNumber.hasSolution()) {
          print(
              "Base $base, digits:${nDigits}, "
                  "n: ${tedNumber.value.toRadixString(base)}, "
                  "m: ${tedNumber.reversedValue.toRadixString(base)},  "
                  "${tedNumber.multiple.toRadixString(base)} * "
                  "${tedNumber.value.toRadixString(base)} == "
                  "${tedNumber.reversedValue.toRadixString(base)}");
        }
      }
      stopWatch.stop();
      print("\tProcessed ${nDigits}-digit numbers in base $base in ${stopWatch
          .elapsed.inSeconds} second(s).");
      stopWatch.reset();

    }
  }
  print("Finished at " + (new DateTime.now()).toString());
}
/**
 * This class holds the number to be used to compare against its (in base) reversed form,
 * plus methods to reverse and print them.
 *
 * To compare the two numbers, the forward version has to be able to be reversed,
 * and the two numbers have to be integers in order to do the division.  The numbers,
 * forward and reversed, need to be the specified number of digits, so neither
 * of them can start with a 0 digit.
 *
 * I think that digits are most easily stored as an array of integers or characters,
 * as in List<int>, or as List<String> where each element represents a single digit,
 * in the specified base, like like 15 or "f" in base 16.
 */
class TedNumbers {
  int base;
  int nDigits;
  int value;
  int reversedValue;
  int multiple;
  List<String> digits;

  TedNumbers(int base, int nDigits, int value) {
    this.base = base;
    this.nDigits = nDigits;
    this.value = value;
    this.digits = new List<String>.filled(this.nDigits, '0');
    updateDigits();
  }

  /**
   * Increment "value", and update the digits.
   */
  increment() {
    value++;
    updateDigits();
  }

  /**
   * Update the digits list by converting "value" to a string in the base,
   * then map those characters into "digits" list.
   */
  updateDigits() {
    String digitsStringValue = value.toRadixString(base);
    if (digitsStringValue.length > nDigits) {
      return; // not sure this is best
    }
    digits.fillRange(0, nDigits, "0"); // why not nDigits-1 ?
    int nCharsForValueInBase = digitsStringValue.length;
    for (int ctr = 0; ctr < nCharsForValueInBase; ctr++) {
      digits[nDigits - nCharsForValueInBase + ctr] = digitsStringValue[ctr];
    }
  }

  /**
   * Check if the current (positive integer) value is related to its reversed value
   * by a whole multiple (other than 1) and that both the value and its reverse (as
   * represented in the specified base) are the right number of digits (no leading 0's).
   * If so, then there's a solution, and return it.
   */
  bool hasSolution() {
    if (digits[0] == "0" || digits[nDigits - 1] == "0") {
      return false;
    }
    reversedValue = getReversedValue();
    if (value == reversedValue) {
      return false; // Don't want multiple of 1
    }
    int mDivNRemainder = reversedValue % value;
    if (mDivNRemainder == 0) {
      multiple = reversedValue ~/ value;
      return true;
    }
    return false;
  }

  /**
   * This reverses "digits" and calls a method to get a String representation
   * and then returns that.
   */
  String reverseDigitsAsString() {
    List<String> reversedDigits = digits.reversed.toList(growable:false);
    String reversedStringNDigits = digitsToString(reversedDigits);
    return reversedStringNDigits;
  }

  /**
   * Loops through provided "digits" and converts to a string of equal length.
   * Thus there can be leading 0's.
   * Only called by reverseDigitsAsString.
   */
  String digitsToString(List<String> digits) {
    StringBuffer resultStringBuffer = new StringBuffer();
    for (int ctr = 0; ctr < digits.length; ctr++) {
      String digit = digits.elementAt(ctr);
      resultStringBuffer.write(digit); // writes left to right
    }
    String stringNDigits = resultStringBuffer.toString();
    return stringNDigits;
  }

  /**
   * Calls reverseDigitsAsString and then parses into an int, and returns it.
   * Called by getSolution()
   */
  int getReversedValue() {
    String reversedString = reverseDigitsAsString();
    int reversedValue = int.parse(reversedString, radix:this.base);
    return reversedValue;
  }

  /**
   * Decrement "value", and update the digits.
   */
  decrement() {
    value--;
    updateDigits();
  }

}