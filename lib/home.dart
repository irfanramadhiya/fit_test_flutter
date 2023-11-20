import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_test/service.dart';
import 'package:fit_test/user.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.token});
  final String? token;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEmailVerified = false;
  bool isTokenValid = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
      await Service().updateEmailStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff25367B),
        body: StreamBuilder<List<UserApp>>(
          stream: getUsers(widget.token ?? ""),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text("Something went wrong ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final users = snapshot.data;

              return Center(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Table(
                    border: TableBorder.all(color: Colors.white),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      const TableRow(
                          decoration: BoxDecoration(color: Color(0xff434B8C)),
                          children: [
                            TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("E-mail",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            )),
                            TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("E-mail verification status",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ))
                          ]),
                      ...List.generate(
                        users!.length,
                        (index) => TableRow(children: [
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              users[index].name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          )),
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(users[index].email,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          )),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: users[index].emailVerifivationStatus
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        )))
                        ]),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                  child: Text(
                'No data yet',
                style: TextStyle(color: Colors.white),
              ));
            }
          },
        ));
  }

  Stream<List<UserApp>> getUsers(String token) {
    if (isTokenValid) {
      return FirebaseFirestore.instance.collection("users").snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserApp.fromJson(doc.data()))
              .toList());
    }
    return const Stream.empty();
    // if(token ==  FirebaseAuth.instance.currentUser?.getIdToken()){
    //   return FirebaseFirestore.instance
    //   .collection("users")
    //   .snapshots()
    //   .map((snapshot) =>
    //       snapshot.docs.map((doc) => UserApp.fromJson(doc.data())).toList());
    // }
    // return [];
  }
}
