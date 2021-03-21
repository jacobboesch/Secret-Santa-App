/*
* Interface for participant service
*/
/*
* Performs CRUD operations oon the participant
* is responsible for creating, retriving, updating, and deleting participants
*/
import 'package:secret_santa_app/db/database_service.dart';
import 'package:secret_santa_app/models/participant.dart';
import 'package:sqflite/sqflite.dart';

// TODO make partent class for CRUD service and have this one extend it
class ParticipantService {
  final DatabaseService _dbService = DatabaseService();
  final String tableName = "vw_participants";

  // returns a list of participants from the database
  Future<List<Participant>> fetchParticipants() async {
    // get the database connection
    Database db = await _dbService.database;
    // get a list of participants from the database
    List<Map<String, dynamic>> dbResults = await db.query(tableName);

    // map the results to a list of participants
    List<Participant> participants =
        dbResults.map((e) => Participant.fromJson(e)).toList();
    return participants;
  }

  // creates a new participant in the database
  // TODO add error handling
  Future<void> createParticipant(Participant participant) async {
    Database db = await _dbService.database;
    await db.insert(tableName, participant.toMap());
  }

  // TODO test this method and add error handling
  Future<void> deleteParticipant(Participant participant) async {
    Database db = await _dbService.database;
    await db.delete(tableName, where: "id = ?", whereArgs: [participant.id]);
  }

  // TODO test this and add error handling
  Future<void> updateParticipant(Participant participant) async {
    Database db = await _dbService.database;
    await db.update(tableName, participant.toMap(),
        where: "id = ?", whereArgs: [participant.id]);
  }
}
