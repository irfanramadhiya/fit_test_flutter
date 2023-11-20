import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_test/forgot_password.dart';
import 'package:fit_test/home.dart';
import 'package:fit_test/register.dart';
import 'package:fit_test/service.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isHidden = true;
  String errorMsg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff25367B),
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
                  obscureText: isHidden,
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
                            isHidden = !isHidden;
                          });
                        },
                        child: isHidden
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
                    final checkLowercase = value?.contains(RegExp(r'[a-z]'), 0);
                    final checkNumbers = value?.contains(RegExp(r'[0-9]'), 0);
                    final checkUppercase = value?.contains(RegExp(r'[A-Z]'), 0);
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
                            await Service().signIn(_email.text, _password.text);
                            try {
                              String? token = await Service().getToken();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => Home(
                                            token: token,
                                          ))));
                            } on FirebaseAuthException catch (e) {
                              print(e.message);
                              setState(() {
                                errorMsg = e.message!;
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            setState(() {
                              errorMsg = e.message!;
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Login',
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
                              builder: ((context) => const ForgotPassword())));
                    },
                    child: const Text(
                      'Forgot password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff45CDDC),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xff45CDDC),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Register())));
                    },
                    child: const Text(
                      'Create new account?',
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
