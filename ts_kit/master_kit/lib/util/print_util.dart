
// TODO support variable number of parameters
void errorPrint(dynamic message) {
  // TODO try to find solution which prints to std err output when available but more importantly, always prints
  print(message);
  // TODO is this condition needed? Does universal io work on the web?
  // if (Platform.current.isWeb) {
  //   print(message);
  // } else {
  //   print(message);
  //   // io.stderr.addError(message);
  // }
}
