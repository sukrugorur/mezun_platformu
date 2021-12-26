import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  final formKey = GlobalKey<FormState>();
  String mail = "";
  Future<dynamic> resetPasswordData;

  // ŞİFRE YENİLEME İSTEĞİ
  Future<dynamic> forgotPassword(String email) async {
    final response = await http.post(
      "http://10.0.2.2:5000/auth/forgotpassword",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else if (response.statusCode == 400) {
      var decodedJson = jsonDecode(response.body);
      return decodedJson;
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<void> _showMyDialog(String message, bool isSuccess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Anladım'),
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.of(context).pop();
                } else {
                  return null;
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF73AEF5), elevation: 0),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.3, 0.5, 0.7],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.cover,
                                width: 175,
                                height: 175,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Şifreyi Sıfırla",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("E-posta"),
                                SizedBox(height: 10),
                                Container(
                                  decoration: kBoxDecorationStyle,
                                  alignment: Alignment.centerLeft,
                                  height: 60,
                                  child: TextFormField(
                                    validator: confirmEmail,
                                    onSaved: (value) => mail = value,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 14),
                                      prefixIcon: Icon(Icons.mail, color: Colors.white),
                                      hintText: "E-postanızı giriniz",
                                    ),
                                  ),
                                ),
                                SizedBox(height: 100),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25),
                              width: double.infinity,
                              child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () {
                                  if (confirmInput()) {
                                    resetPasswordData = forgotPassword(mail).then((value) {
                                      if (value["success"]) {
                                        _showMyDialog(value["message"], value["success"]);
                                      } else {
                                        _showMyDialog(value["message"], value["success"]);
                                      }
                                    });
                                  }
                                },
                                padding: EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                color: Colors.white,
                                child: Text(
                                  "Şifremi Yenile",
                                  style: TextStyle(
                                      color: Color(0xFF527DAA),
                                      letterSpacing: 1.5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String confirmEmail(String mail) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(mail)) {
      return "Lütfen geçerli mail adresi giriniz";
    } else
      return null;
  }

  bool confirmInput() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else
      return false;
  }
}
