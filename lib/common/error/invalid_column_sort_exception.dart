import 'package:rover/common/error/rover_exception.dart';

class InvalidColumnSortException extends RoverException {
  InvalidColumnSortException({super.message, super.cause});
}
