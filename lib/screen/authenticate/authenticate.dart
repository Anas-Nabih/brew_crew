import 'package:brew_crew/screen/authenticate/register.dart';
import 'package:brew_crew/screen/authenticate/signin.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  final AuthService _auth = AuthService();

  bool showSignIn = true;
  void toggelView(){
    setState(() =>showSignIn = !showSignIn );
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn){
      return SignIn(toggelView:toggelView);
    }else{
      return Register(toggelView:toggelView);
    }
  }
}
