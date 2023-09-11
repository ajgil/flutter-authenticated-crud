class WrongCredentials implements Exception{}
class ConnectionTimeout implements Exception{}
class InvalidToken implements Exception{}

class CustomError implements Exception {
  late final String message;
  //bool loggedRequired; // si el logged es true podemos almacenar los errores

  CustomError(this.message); //[this.loggedRequired = false]);
}