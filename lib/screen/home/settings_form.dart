import 'package:brew_crew/models/theuser.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ["0", "1", "2", "3", "4", "5"];

  // form values
  String _currentName;
  String _currentSugars;
  int   _currentStrength;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    print(user);
    // open in vs code .. font is too smaller i cant see.. ok   wait secondes
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: _authService.getUser().uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
// ok np    make a zoom .. make font bigger .. how?
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your brew settings ',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    decoration:
                        textInputDecoration.copyWith(hintText: "Enter a name"),
                    validator: (val) => val.isEmpty ? "Enter a name" : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                          value: sugar, child: Text("$sugar sugars"));
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val),
                  ),

                  // slider
                  SliderTheme(
                data: SliderTheme.of(context).copyWith(
                inactiveTrackColor: Colors.brown[100],
                activeTrackColor:  Colors.brown[400],
                thumbColor: Colors.brown[600],
                overlayColor: Colors.brown[200],
                inactiveTickMarkColor: Colors.brown[100],
                activeTickMarkColor: Colors.brown[400],
                thumbShape:RoundSliderThumbShape(enabledThumbRadius: 10)
                ),
                child:  Slider(
                      value: (_currentStrength ?? userData.strength).toDouble(),
                      activeColor:
                          Colors.brown[_currentStrength ?? userData.strength],
                      inactiveColor:
                          Colors.brown[_currentStrength ?? userData.strength],
                      min: 00,
                      max: 900,
                      divisions: 9,
                      onChanged: (val) =>
                          setState(() {
                            _currentStrength = val.round();
                          }),
                    ),
                ),


                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      if (_formKey.currentState.validate()){
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars ?? userData.sugars,
                            _currentName ?? userData.name,
                            _currentStrength ?? userData.strength);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

