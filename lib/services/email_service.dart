/* 
 * This class is responsible for sending emails out to all of the
 * participants
 */
import 'dart:convert';
import 'package:secret_santa_app/exceptions/error_exception.dart';
import 'package:secret_santa_app/models/selection.dart';
import 'package:http/http.dart' as http;

class EmailService {
  final baseURL = "10.0.2.2:5000";
  // emails participants from the list of selections
  Future<void> emailParticipants(List<Selection> selections) async {
    final response = await http.post(Uri.http(baseURL, "email_participants"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(selections.map((e) => e.toMap()).toList()));
    // check for errors
    // since we've already validated the input ahead of time we'll just
    // assume any error is the result of the server for now
    if (response.statusCode != 200) {
      throw ErrorException("Error: Unable to send emails. Try again latter");
    }
  }
}
