import 'package:flutter/material.dart';
import 'bin_list.dart';
import 'auth.dart';

class LoginRoute extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() => new _LoginRouteState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginRouteState extends State<LoginRoute> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _pass;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    //init
    FocusScope.of(context).requestFocus(FocusNode());
    if (_validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });

      if (_formMode == FormMode.LOGIN) {
        authService.emailSignIn(_email, _pass).catchError((error, stackTrace){
          setState(() {
            print('Error : ${error.toString()}');
            _errorMessage = error.toString().split('(').removeLast().split(',').first.replaceAll('_', ' ');
          });
        }).then((user){
          if(user!=null) Navigator.pushReplacementNamed(context, BinListRoute.tag);
        });
      } else {
        authService.emailSignUp(_email, _pass).then((user){

          if(user!=null) {
            authService.sendEmailVerification();
            Navigator.pushReplacementNamed(context, BinListRoute.tag);
            _showVerifyEmailSentDialog();
          }
        }).catchError((error, stackTrace){
          setState(() {
            print('Error : ${error.toString()}');
            _errorMessage = error.toString().split('(').removeLast().split(',').first.replaceAll('_', ' ');
          });
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _googleSignIn() {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    try {
      authService.googleSignIn().then((user){
        if(user!=null) Navigator.pushReplacementNamed(context, BinListRoute.tag);
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        if (_isIos) {
          _errorMessage = e.details;
        } else
          _errorMessage = e.message;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
        );
      },
    );
  }

  Widget _showBody() {
    return new Center(
        child: new Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 24.0, right: 24.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _showLogo(),
                _showEmailInput(),
                _showPasswordInput(),
                _showPrimaryButton(),
                _showSecondaryButton(),
                _showErrorMessage(),
                _showGoogleSignIn(),
                Builder(
                  builder: (BuildContext context){
                    return _showMobileSignIn(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Center(
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: new TextFormField(
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.white70,
          ),
          contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
          fillColor: Colors.white,
          hintText: 'Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.white70,
          ),
          contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _pass = value.trim(),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white70))
          : new Text('Have an account? Sign in',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white70)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: _formMode == FormMode.LOGIN
                ? new Text('Login',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white))
                : new Text('Create account',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget _showGoogleSignIn() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.white,
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
                Text('Sign In With Google'),
              ],
            ),
            onPressed: _googleSignIn,
          ),
        ));
  }

  Widget _showMobileSignIn(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.white,
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
                Text('Sign In With Mobile'),
              ],
            ),
            onPressed: (){
              final scaffold = Scaffold.of(context);
              scaffold.showSnackBar(
                SnackBar(
                  content: const Text('This option will be available soon!'),
                ),
              );
            },
          ),
        ));
  }
}
