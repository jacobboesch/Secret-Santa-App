/*
 * Responisble for CRUD operations with household
 */

import 'package:secret_santa_app/models/household.dart';
import 'package:secret_santa_app/services/crud_service.dart';
import 'package:sqflite/sqflite.dart';

class HouseholdService extends CRUDService<Household> {
  HouseholdService() : super("households");

  @override
  Future<void> create(Household household) async {
    Database db = await dbService.database;
    await db.insert(tableName, household.toMap());
  }

  @override
  Future<void> delete(Household household) async {
    Database db = await dbService.database;
    await db.delete(tableName, where: "id = ?", whereArgs: [household.id]);
  }

  @override
  Future<List<Household>> fetchAll() async {
    Database db = await dbService.database;
    List<Map<String, dynamic>> dbResults = await db.query(tableName);
    List<Household> households =
        dbResults.map((e) => Household.fromJson(e)).toList();
    return households;
  }

  @override
  Future<void> update(Household household) async {
    Database db = await dbService.database;
    await db.update(tableName, household.toMap(),
        where: "id = ?", whereArgs: [household.id]);
  }
}
