import 'package:brew_crew/models/theuser.dart';
import 'package:brew_crew/screen/authenticate/authenticate.dart';
import 'package:brew_crew/screen/authenticate/register.dart';
import 'package:brew_crew/screen/authenticate/signin.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
