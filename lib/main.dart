import 'package:flutter/material.dart';
import 'auth.dart';
import 'login_page.dart';
import 'bin_list.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String,WidgetBuilder>{
    LoginRoute.tag: (context) => LoginRoute(),
    BinListRoute.tag: (context) => BinListRoute(),
//    MapsRoute.tag: (context) => MapsRoute(),
  };

  Widget _route(){
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot){
        if(snapshot.hasData){
          print('user present');
          return BinListRoute();
        }else{
          print('no user present, login to continue');
          return LoginSignUpPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
      ),
      home: _route(),
      routes: routes,
    );
  }
}
