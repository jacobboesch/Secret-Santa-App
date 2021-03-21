class Household {
  int _id;
  String _household;

  Household(this._id, this._household);

  Household.withoutId(this._household);

  factory Household.fromJson(Map<String, dynamic> json) {
    return new Household(json["id"], json["household"]);
  }

  // Convert particpant to map
  Map<String, dynamic> toMap() {
    return {'id': _id, 'household': _household};
  }

  get id {
    return this._id;
  }

  set id(int id) {
    this._id = id;
  }

  get household {
    return this._household;
  }

  set household(String household) {
    this._household = household;
  }
}
