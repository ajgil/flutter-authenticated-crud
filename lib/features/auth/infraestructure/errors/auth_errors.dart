class WrongCredentials implements Exception{}
class ConnectionTimeout implements Exception{}
class InvalidToken implements Exception{}

class CustomError implements Exception {
  late final String message;
  late final int errorCode;

  CustomError(this.message, this.errorCode);
}