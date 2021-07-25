import 'package:brew_crew/models/theuser.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // creat user obj based on firebaseUser
  TheUser _userFromFirebase (User user){
    return user != null? TheUser(uid: user.uid): null;
  }

  // auth change user stream
  Stream<TheUser> get user{
    return _auth.authStateChanges()
        .map((User user ) => _userFromFirebase(user));
  }

  // sign in anon
 Future signInAnon () async {

   try{
     UserCredential userCredential = await _auth.signInAnonymously();
     User user = userCredential.user;
     return _userFromFirebase(user);

   }catch(e){
     print(e.toString());
     return null;
   }
 }

  // sing in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
  try{
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;
    return _userFromFirebase(user);
  } catch(e){
    print(e.toString());
    return null;
  } 
  }
  
  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // create a new doc for the user wit uid
      await DatabaseService(uid: user.uid).updateUserData("0", "new crew member", 100);

      return _userFromFirebase(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
   Future signOut()async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
   }
  getUser()  {
    return  _auth.currentUser;
  }
}