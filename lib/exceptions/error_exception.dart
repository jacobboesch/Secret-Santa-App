/* Custom exception for the secret santa program
 * This way we know that the exception was something that's 
 * safe to present to the user and not a generic dart exception
 */

class ErrorException implements Exception {
  final String msg;
  ErrorException(this.msg);
}
