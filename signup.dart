import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/pages/auth/mailConfirm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameField = TextEditingController();
  TextEditingController _lastNameField = TextEditingController();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _cpasswordField = TextEditingController();
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
                      "Inscription",
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
                        children: [
                          Container(
                            child: TextFormField(
                              controller: _firstNameField,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Indiquez un nom";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 20, top: 1, bottom: 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Prénoms",
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _lastNameField,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Champ vide";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 20, top: 1, bottom: 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Nom",
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _emailField,
                              keyboardType: TextInputType.emailAddress,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Champ vide";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 20, top: 1, bottom: 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Email",
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
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
                                contentPadding: const EdgeInsets.only(
                                    left: 20, top: 1, bottom: 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Mot de passe",
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _cpasswordField,
                              obscureText: _obscureText,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Champ vide";
                                }
                                if (value != _passwordField.text) {
                                  return "Les mots de passe sont différents";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 20, top: 1, bottom: 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Confirmez le mot de passe",
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: ElevatedButton(
                              child: Text("Inscription"),
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder()),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _emailField.text,
                                            password: _passwordField.text)
                                        .then((value) {
                                      FirebaseAuth.instance.currentUser!
                                          .sendEmailVerification();
                                      print("Email sent!!!!!!");
                                    });
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool("isLoggedIn", true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MailConfirm(
                                              userFirstName:
                                                  _firstNameField.text,
                                              userLastName:
                                                  _lastNameField.text);
                                        },
                                      ),
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    switch (e.code) {
                                      case 'email-already-in-use':
                                        alertMessage =
                                            "Cet adresse mail est déjà associée à un autre compte.";
                                        break;
                                      case 'invalid-email':
                                        alertMessage = "Adresse mail invalide.";
                                        break;
                                      case 'weak-password':
                                        alertMessage =
                                            "Mot de passe trop faible. Veuillez choisir un mot de passe plus sécurisé.";
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
                                Text("Vous avez déjà un compte?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Connexion"),
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
