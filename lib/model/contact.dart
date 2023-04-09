import "package:firebase_database/firebase_database.dart";

//creating a model of Contact
class Contact {
  //model variables
  String _id = "";
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _phone = "";
  String _address = "";
  String _photoUrl = "";

  //constructur to add contact:
  Contact(this._firstName, this._lastName, this._email, this._phone, this._address, this._photoUrl);

  //constructor to edit contact:
  Contact.withId(this._id, this._firstName, this._lastName, this._email, this._phone, this._address, this._photoUrl);

  //getters
  String get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  String get photoUrl => _photoUrl;

  //setters
  set firstName(String firstName) {
    _firstName = firstName;
  }

  set lastName(String lastName) {
    _lastName = lastName;
  }

  set email(String email) {
    _email = email;
  }

  set phone(String phone) {
    _phone = phone;
  }

  set address(String address) {
    _address = address;
  }

  set photoUrl(String photoUrl) {
    _photoUrl = photoUrl;
  }

  //Creating methods to convert firebase JSON file aka snapshot to contact object &vice-versa

  Contact.fromSnapShot(DataSnapshot snapshot) {
    _id = snapshot.key.toString();
    _firstName = (snapshot.value as dynamic)["firstName"];
    _lastName = (snapshot.value as dynamic)["lastName"];
    _email = (snapshot.value as dynamic)["email"];
    _phone = (snapshot.value as dynamic)["phone"];
    _address = (snapshot.value as dynamic)["address"];
    _photoUrl = (snapshot.value as dynamic)["photoUrl"];
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": _firstName.replaceFirst(_firstName[0], _firstName[0].toUpperCase()),
      "lastName": _lastName.replaceFirst(_lastName[0], _lastName[0].toUpperCase()),
      "email": _email,
      "phone": _phone,
      "address": _address,
      "photoUrl": _photoUrl
    };
  }
}
