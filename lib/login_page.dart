import 'package:flutter/material.dart';
import 'bin_list.dart';
import 'auth.dart';

class LoginRoute extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _pass;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _showBody(){
    final headline = Hero(
      tag: 'hero',
      child: Center(
        child: Text(
          'Sign In',
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'username@something.com',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value.trim(),
    );

    final password = TextFormField(
      autofocus: false,
      //initialValue: 'secret password',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onSaved: (value) => _pass = value.trim(),
    );

    final loginButton = Padding(
      padding: EdgeInsets.only(
        top: 24.0,
      ),
      child: RaisedButton(
        child: Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.lightBlueAccent,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        padding: EdgeInsets.all(12.0),
        onPressed: () {
          if(_validateAndSave()){
            print(_email);
            authService.emailSignIn(_email, _pass);
            _checkSignedIn();
          }
        },
      ),
    );

    final googleSignIn = Expanded(
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 1.5)],
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          onPressed: (){
            authService.googleSignIn();
            _checkSignedIn();
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Image.asset(
                  'assets/icons/google.png',
                  height: 25.0,
                  width: 25.0,
                ),
              ),
              Text('Google'),
            ],
          ),
        ),
      ),
    );

    final numberSignIn = Expanded(
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 1.5)],
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          onPressed: () {
            print('Mobile sign in');
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Image.asset(
                  'assets/icons/phone.png',
                  height: 25.0,
                  width: 25.0,
                ),
              ),
              Text('Mobile Number'),
            ],
          ),
        ),
      ),
    );

    final alternateSignIn = Row(
      children: <Widget>[
        googleSignIn,
        SizedBox(
          width: 10.0,
        ),
        numberSignIn,
      ],
    );

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          headline,
          SizedBox(
            height: 50.0,
          ),
          email,
          SizedBox(
            height: 8.0,
          ),
          password,
          SizedBox(
            height: 24.0,
          ),
          loginButton,
          SizedBox(
            height: 8.0,
          ),
          alternateSignIn,
          _showErrorMessage(),
        ],
      ),
    );
  }

  Widget _showErrorMessage() {
      return new Text(
        'No Error',
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showBody(),

        ],
      ),
    );
  }

  _checkSignedIn(){
    StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot){
        if(snapshot.hasData) {

          Navigator.pushReplacementNamed(context, BinListRoute.tag);
        }else{

        }
        return null;
      },
    );
  }

  _LoginRouteState();
}
