import 'package:flutter/material.dart';
import 'navigation_menu.dart';
import 'auth.dart';

class ProfileRoute extends StatefulWidget{
  static String tag = 'profile-page';

  @override
  _ProfileRouteState createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {

  String _userName;

  String _userMail;

  String _userPhone;

  String _phone;

  Widget _userPhoto = Image.asset('assets/icons/user.png');

  String _message = '';

  final myController = TextEditingController();

  @override
  void initState() {
    authService.getPhone().then((phn) {
      setState(() {
        _phone = phn ?? 'Phone number';
        if(_phone == "")
          _phone = 'Phone number';
      });
    });
    authService.getUser().then((user) {
      setState(() {
        _userName = user.displayName;
        _userMail = user.email;
        _userPhoto = Image.network(user.photoUrl);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Stack(
        children: <Widget>[
          _showBody(),
        ],
      ));
  }

  Widget _showBody() {
    return new Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 24.0, right: 24.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                    child:  _userPhoto,
                  ),
                ),
                Center(child: Text(_userName ?? 'anonymous', style: TextStyle(fontSize:25, color: Colors.white),)),
                Center(child: Text(_userMail ?? 'loading..', style: TextStyle(fontSize:17, color: Colors.white),)),
                _showPhoneInput(),
                Center(child: Text('Phone number can also be used to login with OTP in upcoming updates. ',style: TextStyle(color: Colors.white))),
                _showPrimaryButton(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(_message ,style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ));
  }

  Widget _showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextField(
        controller: myController,
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: _phone,
          icon: new Icon(
            Icons.phone,
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
      ),
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
              child:new Text('Update',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: _updatePhone,
            ),
          ));
  }

  _updatePhone() {
    if(myController.text.trim().isEmpty){
      setState((){
        _message = 'Enter new number to update.';
      });
      return;
    }
    setState((){
      _message = 'Updating phone number...!';
    });
    authService.updatePhoneNumber(myController.text).then((val){
      setState((){
        _message = 'Updated!';
      });
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

}

