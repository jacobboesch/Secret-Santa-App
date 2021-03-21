import 'package:flutter_test/flutter_test.dart';
import 'package:secret_santa_app/models/participant.dart';

final jsonTestData = {
  "id": 1,
  "name": "Jacob",
  "household": "Home",
  "email": "test@example.com"
};

final Participant testParticipant =
    Participant(1, "Jacob", "Home", "test@example.com");

void main() {
  test("Participant from json", testParticipantFromJson);
  test("Participant to map", testParticipantToMap);
}

void testParticipantFromJson() {
  final Participant participant = Participant.fromJson(jsonTestData);
  expect(participant.id, 1);
  expect(participant.name, "Jacob");
  expect(participant.household, "Home");
  expect(participant.email, "test@example.com");
}

void testParticipantToMap() {
  var participantMap = testParticipant.toMap();
  expect(participantMap["id"], 1);
  expect(participantMap["name"], "Jacob");
  expect(participantMap["household"], "Home");
  expect(participantMap["email"], "test@example.com");
}
