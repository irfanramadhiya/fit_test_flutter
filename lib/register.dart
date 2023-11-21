import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_test/login.dart';
import 'package:fit_test/service.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  String errorMsg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff25367B),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff25367B),
          title: const Text(
            "Create new account",
            style: TextStyle(color: Colors.white),
          )),
      body: Column(
        children: [
          Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _name,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          icon: Icon(
                            Icons.person,
                            color: Colors.white,
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name can't be empty";
                        } else if (value.length < 3 || value.length > 50) {
                          return "Name must be between 3 to 50 characters";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                        } else if (!EmailValidator.validate(value)) {
                          return "E-mail is invalid";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: isHiddenPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          icon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isHiddenPassword = !isHiddenPassword;
                              });
                            },
                            child: isHiddenPassword
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                  ),
                          )),
                      validator: (value) {
                        final checkLowercase =
                            value?.contains(RegExp(r'[a-z]'), 0);
                        final checkNumbers =
                            value?.contains(RegExp(r'[0-9]'), 0);
                        final checkUppercase =
                            value?.contains(RegExp(r'[A-Z]'), 0);
                        if (value!.isEmpty) {
                          return "Password can't be empty";
                        } else if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        } else if (!checkUppercase! ||
                            !checkLowercase! ||
                            !checkNumbers!) {
                          return "Must contain uppercase, lowercase and number";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _confirmPassword,
                      obscureText: isHiddenConfirmPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          icon: const Icon(
                            Icons.lock_clock_sharp,
                            color: Colors.white,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isHiddenConfirmPassword =
                                    !isHiddenConfirmPassword;
                              });
                            },
                            child: isHiddenConfirmPassword
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                  ),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Confirm password can't be empty";
                        } else if (value != _password.text) {
                          return "Confirm password and password does not match";
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
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)))),
                          onPressed: () async {
                            final isValid = formKey.currentState!.validate();

                            if (isValid) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ));
                              try {
                                await Service().signUp(
                                    _name.text, _email.text, _password.text);
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => const Login())));
                              } on FirebaseAuthException catch (e) {
                                Navigator.of(context).pop();
                                print(e.message);
                                setState(() {
                                  errorMsg = e.message!;
                                });
                              }
                            }
                          },
                          child: const Text(
                            'Register',
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
        ],
      ),
    );
  }
}
