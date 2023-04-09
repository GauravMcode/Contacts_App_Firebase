import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../model/contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class EditContact extends StatefulWidget {
  String id;
  EditContact(this.id, {super.key});
  @override
  State<EditContact> createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  String id;
  _EditContactState(this.id);

  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _phone = "";
  String _address = "";
  String _photoUrl = "empty";
  Contact? _contact;

  //text editing controller

  final TextEditingController _fnController = TextEditingController();
  final TextEditingController _lnController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _emController = TextEditingController();
  final TextEditingController _adController = TextEditingController();

  bool isLoading = true;
  bool isLoadingI = false;

  //db/firebase helper
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    //get contact from firebase
    getcontact(id);
  }

  getcontact(id) async {
    _databaseReference.child(id).onValue.listen((event) {
      _contact = Contact.fromSnapShot(event.snapshot);

      setState(() {
        _firstName = _contact!.firstName;
        _lastName = _contact!.lastName;
        _email = _contact!.email;
        _phone = _contact!.phone;
        _address = _contact!.address;
        _photoUrl = _contact!.photoUrl;

        isLoading = false;
      });

      _fnController.text = _firstName;
      _lnController.text = _lastName;
      _emController.text = _email;
      _phController.text = _phone;
      _adController.text = _address;
    });
  }

  updateContact(BuildContext context) async {
    if (_firstName != "" && _lastName != "" && _phone != "" && _address != "" && _email != "") {
      Contact contact = Contact.withId(id, _firstName, _lastName, _email, _phone, _address, _photoUrl);

      await _databaseReference.child(id).set(contact.toJson());
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
                  child: const Text("Close"),
                )
              ],
            );
          }));
    }
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
    //upload image
    storageReference.putData(await file!.readAsBytes()).whenComplete((() => null)).then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();

      setState(() {
        _photoUrl = downloadUrl;
        isLoadingI = _photoUrl == "empty" ? true : false;
      });
    });
  }

  navigateToLastScreen(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Contact"),
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: (() {
                            setState(() {
                              isLoadingI = true;
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
                        controller: _fnController,
                        textCapitalization: TextCapitalization.words,
                        onChanged: ((value) {
                          setState(() {
                            _firstName = value;
                          });
                        }),
                        decoration: InputDecoration(
                            icon: const Icon(Icons.perm_identity, color: Colors.blue),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                            fillColor: Colors.blue),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(40.0, 20.0, 0, 0),
                      child: TextField(
                        controller: _lnController,
                        textCapitalization: TextCapitalization.words,
                        onChanged: ((value) {
                          setState(() {
                            _lastName = value;
                          });
                        }),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                            fillColor: Colors.blue),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _emController,
                        onChanged: ((value) {
                          setState(() {
                            _email = value;
                          });
                        }),
                        decoration: InputDecoration(
                            icon: const Icon(Icons.email, color: Colors.blue),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                            fillColor: Colors.blue),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _phController,
                        onChanged: ((value) {
                          setState(() {
                            _phone = value;
                          });
                        }),
                        decoration: InputDecoration(
                            icon: const Icon(Icons.phone_android, color: Colors.blue),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.blue)),
                            fillColor: Colors.blue),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _adController,
                        onChanged: ((value) {
                          setState(() {
                            _address = value;
                          });
                        }),
                        decoration: InputDecoration(
                            icon: const Icon(Icons.home, color: Colors.blue),
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
                          updateContact(context);
                        }),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        child: const Text("Update", style: TextStyle(fontSize: 20.0, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
