import 'package:admin_website/selection.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginState createState() => _LoginState();
}

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 70.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(10.0)),
                      TextFormField(
                        obscureText: false,
                        validator: validateName,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Username",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      TextFormField(
                        obscureText: true,
                        validator: validatePassword,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: RaisedButton(
                            color: Color(0xff01A0C7),
                            onPressed: _validateInputs,
                            child: Text('Submit'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new Selection()));
    }
  }

  String validateName(String value) {
    if (value == 'quizadmin') {
      return null;
    } else {
      return "Username is incorrect";
    }
  }

  String validatePassword(String value) {
    if (value == 'quiz123') {
      return null;
    } else {
      return "incorrect password";
    }
  }
}
