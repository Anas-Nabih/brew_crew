import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggelView;
  Register({this.toggelView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error ="";

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Sign Up to Brew Crew"),
        elevation: 0.0,
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign In"),
            onPressed: (){
              widget.toggelView();
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/coffee_bg_register.jpg"),
              fit: BoxFit.cover,
            )
        ),
        padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 12,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Enter your email"),
                validator: (val)=> val.isEmpty? "Enter an email":null,
                onChanged: (val){
                  setState(()=> email=val);
                },
              ),
              SizedBox(height: 12,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Enter your password"),
                validator: (val)=> val.length < 6? "Enter a password 6+ chars long":null,
                obscureText: true,
                onChanged: (val){
                  setState(()=> password=val);
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                  color: Colors.pink,
                  child: Text("Register",style: TextStyle(color: Colors.white),),
                  onPressed: () async{
                    if(_formKey.currentState.validate())
                      {
                        setState(()=> loading = true);
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if (result == null){
                          setState(() {
                            error = "Please Enter A Valid Email";
                            loading = false;
                          });
                        }
                      }
                  }),
              SizedBox(height: 12,),
              Text(
                error,
                style: TextStyle(color: Colors.red,fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
