import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'edit_contact.dart';
import '../model/contact.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewContact extends StatefulWidget {
  String id;
  ViewContact(this.id, {super.key});
  @override
  State<ViewContact> createState() => _ViewContactState(id);
}

class _ViewContactState extends State<ViewContact> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  String id;
  _ViewContactState(this.id);
  Contact? _contact;
  bool isLoading = true;

  getContact(id) async {
    _databaseReference.child(id).onValue.listen((event) {
      setState(() {
        _contact = Contact.fromSnapShot(event.snapshot);
        isLoading = false;
      });
    });
  }

  deleteContact() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("Delete Contact"),
            content: const Text("Do you want to delete this contact?"),
            actions: [
              MaterialButton(
                  onPressed: (() async {
                    navigateToLastScreen();
                    await _databaseReference.child(id).remove();
                    navigateToLastScreen();
                  }),
                  child: const Text("Yes")),
              MaterialButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                  child: const Text("No")),
            ],
          );
        }));
  }

  callAction(String number) async {
    Uri url = Uri.parse("tel: $number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not call  $number";
    }
  }

  smsAction(String number) async {
    Uri url = Uri.parse("sms: $number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not send sms to $number";
    }
  }

  @override
  void initState() {
    super.initState();
    getContact(id);
  }

  navigateToLastScreen() {
    Navigator.of(context).pop();
  }

  navigatetoEditScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
      return EditContact(id);
    })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Contact"),
      ),
      body: Container(
        child: isLoading == true
            ? const CircularProgressIndicator()
            : ListView(
                children: [
                  SizedBox(
                    height: 200.0,
                    child: Image(
                      image: _contact?.photoUrl == "empty" ? const AssetImage("assets/mascot.png") : (NetworkImage((_contact?.photoUrl).toString()) as dynamic),
                      fit: BoxFit.contain,
                    ),
                  ),
                  //name
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          const Icon(Icons.perm_identity),
                          Container(width: 10.0),
                          Text(
                            "${_contact?.firstName} ${_contact?.lastName}",
                            style: const TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                    ),
                  ),
                  //phone
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          const Icon(Icons.phone_android),
                          Container(width: 10.0),
                          Text(
                            "${_contact?.phone}",
                            style: const TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                    ),
                  ),
                  //email
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          const Icon(Icons.email),
                          Container(width: 10.0),
                          Text(
                            "${_contact?.email}",
                            style: const TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                    ),
                  ),
                  //address
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          const Icon(Icons.home),
                          Container(width: 10.0),
                          Text(
                            "${_contact?.address}",
                            style: const TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                    ),
                  ),
                  //call and sms
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            iconSize: 30.0,
                            color: Colors.green,
                            onPressed: (() {
                              callAction(_contact!.phone);
                            }),
                            icon: const Icon(Icons.call),
                          ),
                          IconButton(
                            iconSize: 30.0,
                            color: Colors.orangeAccent,
                            onPressed: (() {
                              smsAction(_contact!.phone);
                            }),
                            icon: const Icon(Icons.message),
                          )
                        ],
                      ),
                    ),
                  ),
                  //edit and delete
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            iconSize: 30.0,
                            color: Colors.blue,
                            onPressed: (() {
                              navigatetoEditScreen();
                            }),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            iconSize: 30.0,
                            color: Colors.red,
                            onPressed: (() {
                              deleteContact();
                            }),
                            icon: const Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
