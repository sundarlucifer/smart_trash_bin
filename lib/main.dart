import 'package:flutter/material.dart';
import 'auth.dart';
import 'bin_list.dart';
import 'login.dart';
import 'bin_details.dart';
import 'maps_page.dart';
import 'profile_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String,WidgetBuilder>{
    LoginRoute.tag: (context) => LoginRoute(),
    BinListRoute.tag: (context) => BinListRoute(),
    MapsRoute.tag: (context) => MapsRoute(),
    BinDetailsRoute.tag: (context) => BinDetailsRoute(),
    ProfileRoute.tag: (context) => ProfileRoute(),
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
          return LoginRoute();
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
        primarySwatch: Colors.grey,
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        hintColor: Colors.white70,
        focusColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      home: _route(),
      routes: routes,
    );
  }
}
