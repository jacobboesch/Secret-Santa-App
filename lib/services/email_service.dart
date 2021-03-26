/* 
 * This class is responsible for sending emails out to all of the
 * participants
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secret_santa_app/models/selection.dart';
import 'package:http/http.dart' as http;

class EmailService {
  final baseURL = "68.46.134.62";
  // emails participants from the list of selections
  Future<void> emailParticipants(List<Selection> selections) async {
    final response = await http.post(Uri.https(baseURL, "email_participants"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(selections));
    // TODO check for errors
  }
}
