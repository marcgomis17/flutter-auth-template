import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/pages/root.dart';
import 'package:freelancer/services/data/firestore.dart';

class MailConfirm extends StatefulWidget {
  final String userFirstName;
  final String userLastName;

  MailConfirm({required this.userFirstName, required this.userLastName});

  @override
  _MailConfirmState createState() => _MailConfirmState();
}

class _MailConfirmState extends State<MailConfirm> {
  String? _userMail = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: _height * 0.1),
              Text(
                "Vérification de l'adresse mail",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: _height * 0.05),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    "Un mail de confirmation a été envoyé à $_userMail. Vérifiez votre boîte de réception."),
              ),
              SizedBox(
                height: _height * 0.05,
              ),
              Container(
                child: Column(
                  children: [
                    Text("Vous n'avez pas reçu de mail?"),
                    TextButton(
                      child: Text("Renvoyer"),
                      onPressed: () {
                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    TextButton(
                      child: Text(
                          "Appuyez ici pour être redirigé vers l'application"),
                      onPressed: () {
                        _verifyEmail();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _verifyEmail() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      print("Email verified!!");
      getUserCredentials(widget.userFirstName, widget.userLastName);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Root();
          },
        ),
      );
    } else {
      _showErrorMessage();
    }
  }

  Future<void> _showErrorMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "Votre adresse n'a pas été confirmée. Cliquez sur le lien qui vous a été envoyé."),
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
