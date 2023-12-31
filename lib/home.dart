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
  String value = "All";

  final filters = ["All", "Email Verified"];
  @override
  void initState() async {
    // TODO: implement initState
    super.initState();

    if (widget.token == await Service().getToken()) {
      setState(() {
        isTokenValid = true;
      });
    }

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xff25367B),
              title: const Text(
                "User list",
                style: TextStyle(color: Colors.white),
              )),
          backgroundColor: const Color(0xff25367B),
          body: StreamBuilder<List<UserApp>>(
            stream: getUsers(widget.token ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text("Something went wrong ${snapshot.error}"));
              } else if (snapshot.hasData) {
                List<UserApp>? users;
                final all = snapshot.data;
                final emailVerified = snapshot.data!
                    .where((element) => element.emailVerifivationStatus)
                    .toList();
                if (value == "All") {
                  users = snapshot.data;
                } else {
                  users = emailVerified;
                }

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Filter by: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      DropdownButton<String>(
                        items: filters.map(buildMenuItem).toList(),
                        isExpanded: true,
                        value: value,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        dropdownColor: const Color(0xff25367B),
                        onChanged: (value) {
                          setState(() {
                            this.value = value!;

                            if (value == "All") {
                              users = all;
                            } else {
                              users = emailVerified;
                            }
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Table(
                        border: TableBorder.all(color: Colors.white),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          const TableRow(
                              decoration:
                                  BoxDecoration(color: Color(0xff434B8C)),
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
                                  users![index].name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(users![index].email,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              )),
                              TableCell(
                                  child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child:
                                          users![index].emailVerifivationStatus
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
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String filter) {
    return DropdownMenuItem(
      value: filter,
      child: Text(
        filter,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Stream<List<UserApp>> getUsers(String token) {
    if (isTokenValid) {
      return FirebaseFirestore.instance.collection("users").snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserApp.fromJson(doc.data()))
              .toList());
    }
    return const Stream.empty();
  }
}
