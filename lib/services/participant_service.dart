/*
* Interface for participant service
*/
/*
* Performs CRUD operations oon the participant
* is responsible for creating, retriving, updating, and deleting participants
*/
import 'package:secret_santa_app/models/participant.dart';
import 'package:secret_santa_app/services/crud_service.dart';
import 'package:sqflite/sqflite.dart';

class ParticipantService extends CRUDService<Participant> {
  ParticipantService() : super("vw_participants");

  // returns a list of participants from the database
  Future<List<Participant>> fetchAll() async {
    // get the database connection
    Database db = await dbService.database;
    // get a list of participants from the database
    List<Map<String, dynamic>> dbResults = await db.query(tableName);

    // map the results to a list of participants
    List<Participant> participants =
        dbResults.map((e) => Participant.fromJson(e)).toList();
    return participants;
  }

  // creates a new participant in the database
  Future<void> create(Participant participant) async {
    Database db = await dbService.database;
    await db.insert(tableName, participant.toMap());
  }

  Future<void> delete(Participant participant) async {
    Database db = await dbService.database;
    await db.delete(tableName, where: "id = ?", whereArgs: [participant.id]);
  }

  Future<void> update(Participant participant) async {
    Database db = await dbService.database;
    await db.update(tableName, participant.toMap(),
        where: "id = ?", whereArgs: [participant.id]);
  }
}
