class Participant {
  int _id;
  String _name;
  String _household;
  String _email;

  // Constructors
  Participant(this._id, this._name, this._household, this._email);
  Participant.withoutId(this._name, this._household, this._email);

  factory Participant.fromJson(Map<String, dynamic> json) {
    return new Participant(
        json["id"], json["name"], json["household"], json["email"]);
  }

  // Convert particpant to map
  Map<String, dynamic> toMap() {
    return {'id': _id, 'name': _name, 'household': _household, 'email': _email};
  }

  // getters and setters
  int get id {
    return this._id;
  }

  String get name {
    return this._name;
  }

  set name(String name) {
    this._name = name;
  }

  String get household {
    return this._household;
  }

  set household(String household) {
    this._household = household;
  }

  String get email {
    return this._email;
  }

  set email(String email) {
    this._email = email;
  }
}
