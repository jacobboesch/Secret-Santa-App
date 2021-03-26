/*
 * This class is responsible for selecting giftee's for participants
 */

import 'package:secret_santa_app/db/database_service.dart';
import 'package:secret_santa_app/models/selection.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

class SelectionService {
  final DatabaseService databaseService = DatabaseService();

  Future<List<Selection>> fetchSelections() async {
    Database db = await databaseService.database;

    // retrives a list of all possible giftee's for a given participant id
    // the giftee id's are not the same as the participant, not in the same household as the participant
    // and can't be a giftee id from the previous run
    List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT P.id AS id, COUNT(G.id) AS num_possible_giftees, group_concat(G.id) AS possible_giftees FROM participants AS P, participants AS G WHERE P.id != G.id AND P.household != G.household AND ( (P.id, G.id) NOT IN (SELECT * FROM vw_recent_giftee_history)) GROUP BY P.id ORDER BY num_possible_giftees ASC;");

    // list of possible giftee options for each participant id
    List<Map<String, dynamic>> possibleSelections = results
        .map((e) => {
              "id": e["id"],
              // integer set of all possible giftee's for the given participant
              "possibleGiftees": Set.from(e["possible_giftees"]
                  .split(",")
                  .map((g) => int.parse(g))
                  .toList())
            })
        .toList();
    List<Map<String, dynamic>> selectionResults =
        _getSelectionIds(possibleSelections);

    // if the result is empty don't bother to try and update this history
    // just return empty set so that it doesn't return the previous times results
    if (selectionResults.isEmpty) {
      return [];
    }

    // update the giftee history
    _updateGifteeHistory(selectionResults, db);

    // Get the selections from the most recent giftee history
    List<Map<String, dynamic>> selections = await db.rawQuery(
        "SELECT P.name AS name, P.email AS email, G.name AS gifteeName FROM vw_recent_giftee_history INNER JOIN participants AS P ON P.id = participant INNER JOIN participants AS G ON G.id = giftee;");

    return selections.map((e) => Selection.fromJson(e)).toList();
  }

  // returns a list containing the participant id and the selected giftee id
  // options parameter list of [{"id": <int>, "posssibleGiftees": <Set<int>>}]
  // returns list in the form of [{"participant": <int>, "giftee": <int>}]
  List<Map<String, dynamic>> _getSelectionIds(
      List<Map<String, dynamic>> possibleSelections) {
    // results for the selections containing the participant id and the giftee id
    List<Map<String, dynamic>> selectionResults = [];

    // the set of giftees that are alredy taken
    Set takenGiftees = new Set();
    // The following algorithm only gets usable results about 77% of the time
    // due to there being no possible giftee's left for some people due to it
    // being taken by another person at random.
    // The algorithm can fail upto 8 times at this point there is a 99.999% chance of success
    // otherwise it's likely impossible to match all participants to a giftee
    int failCount = 0;

    while (failCount < 8) {
      try {
        selectionResults.clear();
        takenGiftees.clear();
        // for each participant in the possible selections randomly select
        // a giftee from the remaining possible options, removing any giftee
        // that has already been assigned
        possibleSelections.forEach((possibility) {
          // set of possibleGiftees - takenGiftees
          Set possibleGiftees =
              possibility["possibleGiftees"].difference(takenGiftees);
          // if there are no possible giftees left
          if (possibleGiftees.length == 0) {
            throw Exception("Failed to match giftee for user");
          }

          // get random index
          Random random = new Random();
          int randomIndex = random.nextInt(possibleGiftees.length);
          int gifteeId = possibleGiftees.toList()[randomIndex];
          selectionResults
              .add({"participant": possibility["id"], "giftee": gifteeId});
          takenGiftees.add(gifteeId);
        });

        if (selectionResults.length == possibleSelections.length) {
          break;
        } else {
          throw Exception("Failed to match all participants");
        }
      } catch (e) {
        failCount += 1;
      }
    }

    return selectionResults;
  }

  // saves the selected giftees to the giftee history
  void _updateGifteeHistory(
      List<Map<String, dynamic>> selectionResults, Database db) {
    Batch updateBatch = db.batch();
    selectionResults.forEach((selection) {
      updateBatch.insert("giftee_history", selection);
    });
    updateBatch.commit();
  }
}
