import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/contact.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _phone = "";
  String _address = "";
  String _photoUrl = "empty";
  bool isLoading = false;

  saveContact(BuildContext context) async {
    if (_firstName != "" && _lastName != "" && _phone != "" && _address != "" && _email != "") {
      Contact contact = Contact(_firstName, _lastName, _email, _phone, _address, _photoUrl);
      //to add to database
      await _databaseReference.push().set(contact.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: const Text("Field Required"),
              content: const Text("All fields are required"),
              actions: [
                MaterialButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                  child: Text("Close"),
                )
              ],
            );
          }));
    }
  }

  navigateToLastScreen(context) {
    Navigator.of(context).pop();
  }

  Future pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );
    String filename = p.basename((file?.path).toString());
    uploadImage(file, filename);
  }

  void uploadImage(XFile? file, String filename) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(filename);
    storageReference.putData(await file!.readAsBytes()).whenComplete((() => null)).then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();

      setState(() {
        _photoUrl = downloadUrl;
        isLoading = _photoUrl == "empty" ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: (() {
                      setState(() {
                        isLoading = true;
                      });
                      pickImage();
                    }),
                    child: Center(
                      child: isLoading == true
                          ? const CircularProgressIndicator()
                          : Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _photoUrl == "empty" ? const AssetImage("assets/mascot.png") : (NetworkImage(_photoUrl) as dynamic),
                                  )),
                            ),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  onChanged: ((value) {
                    setState(() {
                      _firstName = value;
                    });
                  }),
                  decoration: InputDecoration(
                      icon: const Icon(Icons.perm_identity, color: Colors.blue),
                      labelText: "First Name",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                      fillColor: Colors.blue),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(40.0, 20.0, 0, 0),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  onChanged: ((value) {
                    setState(() {
                      _lastName = value;
                    });
                  }),
                  decoration: InputDecoration(
                      labelText: "Last Name",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                      fillColor: Colors.blue),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: ((value) {
                    setState(() {
                      _email = value;
                    });
                  }),
                  decoration: InputDecoration(
                      icon: const Icon(Icons.email, color: Colors.blue),
                      labelText: "Email",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                      fillColor: Colors.blue),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: ((value) {
                    setState(() {
                      _phone = value;
                    });
                  }),
                  decoration: InputDecoration(
                      icon: const Icon(Icons.phone_android, color: Colors.blue),
                      labelText: "Phone",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                      fillColor: Colors.blue),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: ((value) {
                    setState(() {
                      _address = value;
                    });
                  }),
                  decoration: InputDecoration(
                      icon: const Icon(Icons.home, color: Colors.blue),
                      labelText: "Address",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                      fillColor: Colors.blue),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(40, 10, 5, 0),
                padding: const EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                  onPressed: (() {
                    saveContact(context);
                  }),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: const Text("Save", style: TextStyle(fontSize: 20.0, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
