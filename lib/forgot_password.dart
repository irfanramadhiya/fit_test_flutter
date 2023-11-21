import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_test/login.dart';
import 'package:fit_test/service.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  String errorMsg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff25367B),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff25367B),
          title: const Text(
            "Forgot password",
            style: TextStyle(color: Colors.white),
          )),
      body: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _email,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      icon: Icon(
                        Icons.email,
                        color: Colors.white,
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "E-mail can't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  errorMsg,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 48,
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff45CDDC)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)))),
                      onPressed: () async {
                        final isValid = formKey.currentState!.validate();

                        if (isValid) {
                          try {
                            await Service().resetPassword(_email.text);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("E-mail sent"),
                            ));
                            const SnackBar(
                              content: Text("E-mail sent"),
                            );
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            setState(() {
                              errorMsg = e.message!;
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Login())));
                    },
                    child: const Text(
                      'Back to login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff45CDDC),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xff45CDDC),
                      ),
                    )),
              ],
            ),
          )),
    );
  }
}
