import 'package:rover/common/error/rover_exception.dart';

class ConnectionException extends RoverException {
  ConnectionException({super.message, super.cause});
}
