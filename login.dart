// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/pages/auth/passwordReset.dart';
import 'package:freelancer/pages/auth/signup.dart';
import 'package:freelancer/pages/root.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  bool _obscureText = true;
  String alertMessage = "";

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            height: _height / 3,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: FlutterLogo(
                      size: 90,
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15, right: 10),
                    child: Text(
                      "Connexion",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _emailField,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Champ vide";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              prefixIcon: Icon(Icons.mail_rounded),
                              hintText: "Email",
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: _passwordField,
                              obscureText: _obscureText,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Champ vide";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                prefixIcon: Icon(Icons.vpn_key_rounded),
                                hintText: "Mot de passe",
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(_obscureText
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded)),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ResetPassword();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("Mot de passe oublié?"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: ElevatedButton(
                              child: Text("Connexion"),
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder()),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _emailField.text,
                                            password: _passwordField.text);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool("isLoggedIn", true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Root();
                                        },
                                      ),
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    switch (e.code) {
                                      case 'invalid-email':
                                        alertMessage =
                                            "Cet adresse mail est invalide.";
                                        break;
                                      case 'user-not-found':
                                        alertMessage =
                                            "Ce compte n'existe pas.";
                                        break;
                                      case 'wrong-password':
                                        alertMessage =
                                            "Mot de passe incorrect.";
                                        break;
                                      default:
                                        return null;
                                    }
                                    print(e.toString());
                                    _showErrorMessage(alertMessage);
                                  }
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Vous n'avez pas de compte"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Signup();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("Inscription"),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showErrorMessage(String errorMsg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(errorMsg),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
