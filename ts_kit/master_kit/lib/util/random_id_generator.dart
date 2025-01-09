import 'dart:math';

// Increase this to 9 or 10 when there is more than 10,000,000 entities
// or compute estimated probability here: https://www.wolframalpha.com/input/?i=1+-+exp%28-10000000%5E2%2F%282*%2862%5E9%29%29%29
// see also first comment here: https://math.stackexchange.com/questions/2115310/random-numbers-generator-and-collision-probability
const SHORT_ID_KEY_LENGTH = 10;
const MEDIUM_ID_LENGTH = 16;
const LONG_ID_LENGTH = 20;
const LONGER_ID_LENGTH = 28;

const ONLY_NUMBERS = '0123456789';
const CAPITALS_AND_NUMBERS = 'QWERTYUIOPASDFGHJKLZXCVBNM1234567890';
const ONLY_LETTERS = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
const LETTERS_AND_NUMBERS = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

Random _rnd = Random();

String generateRandomString({int length = SHORT_ID_KEY_LENGTH, String alphabet = LETTERS_AND_NUMBERS}) {
  return String.fromCharCodes(Iterable.generate(length, (_) => alphabet.codeUnitAt(_rnd.nextInt(alphabet.length))));
}

String generateRandomPassword({int length = SHORT_ID_KEY_LENGTH}) {
  late String string;
  do {
    string = generateRandomString(length: length);
  } while (!string.contains(RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])')));

  return string;
}

String generateMediumRandomString({String alphabet = LETTERS_AND_NUMBERS}) {
  return generateRandomString(length: MEDIUM_ID_LENGTH, alphabet: alphabet);
}

String generateLongRandomString({String alphabet = LETTERS_AND_NUMBERS}) {
  return generateRandomString(length: LONG_ID_LENGTH, alphabet: alphabet);
}
