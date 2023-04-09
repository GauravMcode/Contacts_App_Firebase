import 'package:flutter/material.dart';
import 'view_contact.dart';
import 'add_contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  var colors = [
    Colors.amber,
    Colors.redAccent,
    Colors.blue,
    Colors.blueGrey,
    Colors.white,
    Colors.orange,
    Colors.green,
    Colors.cyan,
  ];

  navigateToAddContact() {
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
      return const AddContact();
    })));
  }

  navigateToViewContact(id) {
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
      return ViewContact(id);
    })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact App"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: ((BuildContext context, snapshot, animation, index) {
            return GestureDetector(
              onTap: () {
                navigateToViewContact(snapshot.key);
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: colors[Random().nextInt(colors.length)],
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    (snapshot.value as dynamic)["photoUrl"] == "empty" ? const AssetImage("assets/mascot.png") : (NetworkImage((snapshot.value as dynamic)["photoUrl"]) as dynamic))),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${(snapshot.value as dynamic)["firstName"]} ${(snapshot.value as dynamic)["lastName"]}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                            Text("${(snapshot.value as dynamic)["phone"]}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}
