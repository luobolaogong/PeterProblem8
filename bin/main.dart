// Copyright (c) 2017, rob. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:math';
import 'package:PeterProblem8/PeterProblem8.dart' as PeterProblem8;

//main(List<String> arguments) {
//  print('Hello world: ${PeterProblem8.calculate()}!');
//}
main(List<String> arguments) {
  int minBase = 10;
  int maxBase = 10;
  int minNDigits = 2;
  int maxNDigits = 2;
  //int maxValue = ((pow(base, nDigits)) / 2.0).ceil();

  for (int base = minBase; base <= maxBase; base++) {
    for (int nDigits = minNDigits; nDigits <= maxNDigits; nDigits++) {
      int maxValue = pow(base, nDigits);
      for (int value = 0; value < maxValue; value++) {
        TedNumber tedNumber = new TedNumber(base, nDigits, value);
        print("Base $base, digits $nDigits: ${tedNumber.toForward()}:${tedNumber.toReversed()}");
      }
    }
  }
  print("Done");
}

// This class holds the number to be used to compare against its reversed form,
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
  //List<String> digits; // do we want to store this and update it every time the number changes?

  TedNumber(int base, int nDigits, int value) {
    this.base = base;
    this.nDigits = nDigits;
    this.value = value;
    //this.digits = new List<String>.filled(this.nDigits, '0'); // want this?
  }

  // What do we want here, say nDigits is 4, and value is 3?  "0011"? "0011:1100" ?
  // Hey this is for printing the class, not value
  String toString() {
    return toForward();
  }

  // We're storing the digits in a array/list of String values, and I prefer to think
  // of the list as going from left to right starting with position 0.  That is, if
  // the number is 3, in base 2 and there are supposed to be 3 digits, then
  // digits[0] is 0, digits[1] is 1, digits[2] is 1. I'm not sure how this is getting stored.
  // check later.

  List<String> reverse(List<String> digits) {
    return digits.reversed;
  }

  List<String> toDigits() {
    String digitsStringValue = value.toRadixString(base);
    List<String> digits = new List<String>.filled(nDigits, '0');
    if (digitsStringValue.length > nDigits) {
      return digits;
    }
    //List<String> digits = new List<String>.filled(nDigits, '0');
    for (int ctr = digitsStringValue.length - 1; ctr >= 0; ctr--) {
      digits[ctr] = digitsStringValue[ctr]; // this looks backwards, as in 3 = [1, 1, 0]
    }
    return digits;
  }

  String digitsToString(List<String> digits) {
    //Probably a better way to do this
    StringBuffer resultString = new StringBuffer();
    //for (int ctr = 0; ctr < this.nDigits; ctr++) {
    for (int ctr = this.nDigits - 1; ctr >= 0; ctr--) {
      String digit = digits.elementAt(ctr);
      resultString.write(digit);
    }
    return resultString.toString();
  }

  String toForward() {
    List<String> digits = toDigits();
    return digitsToString(digits);

//    return digits.toString();
  }

  String toReversed() {
    List<String> digits = new List<String>.from(toDigits().reversed);
    return digitsToString(digits);
  }
}