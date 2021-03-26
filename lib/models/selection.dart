/*
 * This class stores information for the selected giftee for the given participant
 */

class Selection {
  // participants email
  String _email;
  // name of participant
  String _name;
  // name of giftee
  String _gifteeName;

  Selection(this._email, this._name, this._gifteeName);

  factory Selection.fromJson(Map<String, dynamic> json) {
    return new Selection(json["email"], json["name"], json["gifteeName"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "email": this._email,
      "name": this._name,
      "gifteeName": this._gifteeName
    };
  }

  // getters and setters
  get email {
    return this._email;
  }

  set email(String email) {
    this._email = email;
  }

  get name {
    return this._name;
  }

  set name(String name) {
    this._name = name;
  }

  get gifteeName {
    return this._gifteeName;
  }

  set gifteeName(String gifteeName) {
    this._gifteeName = gifteeName;
  }
}
