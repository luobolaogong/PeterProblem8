import 'dart:math';

// Obviously wrong if you look at how this counts.

main(List<String> arguments) {
  int minBase = 10;
  int maxBase = 11;
  int minNDigits = 4;
  int maxNDigits = 6;
  int minValue = 1;

  print("Starting at " + (new DateTime.now()).toString());
  Stopwatch stopWatch = new Stopwatch();

  for (int base = minBase; base <= maxBase; base++) {
    for (int nDigits = minNDigits; nDigits <= maxNDigits; nDigits++) {
      stopWatch.start();

      int maxValue = ((pow(base, nDigits)) / 2.0).ceil();
      //int maxValue = pow(base, nDigits) - 1;
      TedNumber tedNumber = new TedNumber(base, nDigits, minValue);
      for (int value = minValue; value <= maxValue; value++) {
        //print("Base $base, digits $nDigits: ${tedNumber.toDigitsStringNDigits()}:${tedNumber.toReversedDigitsStringNDigits()}");
        tedNumber.increment();
        //Solution solution = tedNumber.getSolution();
        //bool hasSolution = tedNumber.hasSolution();
//        if (solution != null) {
//          print(
//              "Base $base, digits:${nDigits}, "
//                  "n: ${solution.forwardNumber.toRadixString(base)}, "
//                  "m: ${solution.reversedNumber.toRadixString(base)},  "
//                  "${solution.multiple.toRadixString(base)} * "
//                  "${solution.forwardNumber.toRadixString(base)} == ${solution
//                  .reversedNumber.toRadixString(base)}");
//        }
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
  print("Done");
}

/**
 * This class merely holds the solution found so it can be returned by some function.
 */
//class Solution {
//  int multiple;
//  int forwardNumber;
//  int reversedNumber;
//  Solution(this.forwardNumber, this.reversedNumber, this.multiple);
//}

// This class holds the number to be used to compare against its (in base) reversed form,
// and methods to reverse and print them.  When printed, they need to be in the
// specified base.
//
// To compare the two numbers, the forward version has to be able to be reversed,
// and the two numbers have to be integers in order to do the division.  The numbers,
// forward and reversed, need to be the specified number of digits, so neither
// of them can start with a 0 digit, which means the series of digits for the
// forward version cannot start or end with a zero.
//
// So, you have to be able to convert an integer to a series or list of digits
// for checking length and for checking for 0 digits.
//
// You also need to print both the forward and reversed numbers, and they need
// to be strings, or easily converted to strings.
//
// I think that digits are most easily stored as an array of integers, as in
// List<int>, or as List<String> where each element is a single digit, like "f"
// in base 16.  Strings themselves are immutable, so you cannot do something like
// forwardString[2] = "1";  You'd have to do multi-step operations where a new
// String would be created.
//
// Therefore a forward and reversed digits will be of type List<String>.  That
// way I can reverse them easily.  Creating a single string can be done with
// a StringBuffer.  So, forward[2] would be "1", or "a".
//
// The number has to be easily incremented, or set, or maybe decremented.
// So, operators "++", "--", and "=", and "==" overloaded would be good.
//
class TedNumber {
  int base;
  int nDigits;
  int value;
  int reversedValue;
  int multiple;
  List<String> digits; // do we want to store this and update it every time the number changes?

  TedNumber(int base, int nDigits, int value) {
    //print("In constructor");
    this.base = base;
    this.nDigits = nDigits;
    this.value = value;
    this.digits = new List<String>.filled(this.nDigits, '0'); // want this?
    updateDigits(); // update "digits" with "value"
  }

  /**
   * Increment "value", and update the digits.
   */
  increment() {
    //print("In increment()");
    value++;
    updateDigits();
  }
  /**
   * Update the digits list by converting "value" to a string in the base,
   * then transfer those characters into "digits" list.
   */
  updateDigits() {
    //print("In updateDigits()");
    String digitsStringValue = value.toRadixString(base);
    if (digitsStringValue.length > nDigits) {
      return; // not sure this is best
    }
    int nCharsValueInBase = digitsStringValue.length;
    for (int ctr = 0; ctr < nCharsValueInBase; ctr++) {
      digits[nDigits - nCharsValueInBase + ctr] = digitsStringValue[ctr];
    }
    //look for solution
    //return;
  }

  /**
   * Check if the current (positive integer) value is related to its reversed value
   * by a whole multiple (other than 1) and that both the value and its reverse (as
   * represented in the specified base) are the right number of digits (no leading 0's).
   * If so, then there's a solution, and return it.
   */
  //Solution getSolution() {
  bool hasSolution() {
    //print("In getSolution");
    if (digits[0] == "0" || digits[nDigits - 1] == "0") {
      //print("Skipping values not the right length.");
      return false;
    }
    //List<String> reversedDigits = new List<String>.from(digits.reversed);
    //int reversedValue = reversedDigits.................................
//    if (digits == reversedDigits) { // does this work? No, fix this later
//      print("Skipping values that are the same back and forward.");
//      return null;
//    }
    //int reversedValue = getReversedValue();
    reversedValue = getReversedValue();
    int mDivNRemainder = reversedValue % value;
    if (mDivNRemainder == 0) {
      //int wholeNumberMultiple = reversedValue ~/ value;
      multiple = reversedValue ~/ value;
      if (multiple != 1) {
        return true;
      }
      // This slows things down.  Maybe just update the values in this class
      // and return true or false
      //return new Solution(value, reversedValue, wholeNumberMultiple);
      //return true;
    }
    return false;
  }

  //
  // This reverses "digits" and calls a method to get a String representation
  // and then returns that.
  //
  String reverseDigitsAsString() {
    //print("In toReversedDigitsStringNDigits()");
    //List<String> digits = toDigitsList();
    Iterable digitsReversedIterable = digits.reversed;
    List<String> reversedDigits = new List<String>.from(digitsReversedIterable);
    String reversedStringNDigits = digitsToString(reversedDigits);
    return reversedStringNDigits;
  }

  //
  // Loops through provided "digits" and converts to a string of equal length.
  // Thus there can be leading 0's.
  // Only called by reverseDigitsAsString.
  //
  String digitsToString(List<String> digits) {
    //print("In digitsToStringNDigits(digits)");

    StringBuffer resultStringBuffer = new StringBuffer();
    for (int ctr = 0; ctr < digits.length; ctr++) {
      String digit = digits.elementAt(ctr);
      resultStringBuffer.write(digit); // writes left to right
    }
    String stringNDigits = resultStringBuffer.toString();
    return stringNDigits;
  }

  //
  // Calls reverseDigitsAsString and then parses into an int, and returns it.
  // Called by getSolution()
  //
  int getReversedValue() {
    //print("In getReversedValue");

    String reverseString = reverseDigitsAsString();
    int reverseValue = int.parse(reverseString, radix:this.base);
    return reverseValue;
  }







  //  operator +(int more) {
//    value += more;
//  }

  // We're storing the digits in a array/list of String values, and I prefer to think
  // of the list as going from left to right starting with position 0.  That is, if
  // the number is 3, in base 2 and there are supposed to be 3 digits, then
  // digits[0] is 0, digits[1] is 1, digits[2] is 1. I'm not sure how this is getting stored.
  // check later.

  // I don't think this is right.  I don't think a digits.reversed is a List<String>
  List<String> reverse(List<String> digits) {
    print("I think the following is wrong");
    return digits.reversed; // docs say this is an Iterable<E>.  Can that be a List<String>???  If so, why do the more complicated new whatever below?
  }

// What do we want here, say nDigits is 4, and value is 3?  "0011"? "0011:1100" ?
// Hey this is for printing the class, not value
//  String toString() {
//    print("In toString()");
//    return toDigitsStringNDigits();
//  }


//
// This calls another function to get a string representation of "digits",
// and then returns that.  So, why even call this function?
//
//  String toDigitsStringNDigits() {
//    print("In toDigitsStringNDigits()");
//    //List<String> digits = toDigitsList();
//    //String stringNDigits = digitsToStringNDigits(digits);
//    String stringNDigits = getDigitsToStringNDigits();
//    return stringNDigits; // this is a string representation of digits, forced to be nDigits in size, and can have leading 0's.
//  }

// This returns a List<String> representing the value, with current size and base.
// Rather than return it, should we just store it in this class, and just update
// it rather than create a new List<String>?  And if so, should that be done at
// every change to value?  I think it would be faster to update than create new.
//  List<String> toDigitsList() {
//    String digitsStringValue = value.toRadixString(base);
//    List<String> digits = new List<String>.filled(nDigits, '0');
//    if (digitsStringValue.length > nDigits) { // the number in the base is greater than the limit, so return "000" or whatever
//      return digits; // not sure this is best
//    }
//    //List<String> digits = new List<String>.filled(nDigits, '0');
//    // What we want to do is take a digits of ["0", "1", "1"] (for 3)
//    //for (int ctr = digitsStringValue.length - 1; ctr >= 0; ctr--) {
//    int nCharsValueInBase = digitsStringValue.length;
//    for (int ctr = 0; ctr < nCharsValueInBase; ctr++) {
//      //for (int ctr = 0; ctr < digitsStringValue.length; ctr++) {
//      digits[nDigits - nCharsValueInBase + ctr] = digitsStringValue[ctr]; // this looks backwards, as in 3 = [1, 1, 0]
//    }
//    return digits;
//  }

//
// Merely calls digitsToString(digits) and returns the result
//
//  String getDigitsToString() { // converts digits to a string of all nDigits, so can be leading 0's
//    //print("In getDigitsToStringNDigits()");
//    String stringNDigits = digitsToString(digits);
//    return stringNDigits;
//  }

//      print(
//          "Base $base, digits:${getNDigits()}, n: ${odometer
//              .getValue()
//              .toRadixString(base)}, m: ${getReversedValue()
//              .toRadixString(base)},  ${wholeNumberMultiple.toRadixString(
//              base)} * ${getValue().toRadixString(
//              base)} == ${odometer
//              .getReversedValue().toRadixString(base)}");
//continue;


}