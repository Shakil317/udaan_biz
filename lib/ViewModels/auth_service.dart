import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mycalculator/Utils/app_roots.dart';
import 'package:mycalculator/screens/home_tab_bar_screen.dart';
import 'package:mycalculator/screens/user_registation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  File? image;
  String? downloadUrl;
  FirebaseStorage storage = FirebaseStorage.instance;


  TextEditingController userName = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  var perfLogin =   SharedPreferences.getInstance();
  get user => _auth.currentUser;
  bool isChecked = false;

  void checkLoginStatus(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? isLogin = pref.getBool('isLogin');
    if (isLogin != null && isLogin) {
     AppRoot.appRoutRemoveUntil(context: context, page: const HomeTabBarScreens());
    } else {
      AppRoot.appRoutRemoveUntil(context: context, page: const UserRegistationScreen());

    }
  }
  Future<bool?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Login Cancelled");
        return false;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      if (_auth.currentUser != null) {
        Fluttertoast.showToast(msg: "Google Login Success");
        return true;
      }
      return _auth.currentUser != null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Google Login Failed: $e");
      return false;
    }
  }

  Future<void> registerNow({required BuildContext context, required String userName,  required String emailId,required String userPassword}) async{
    var pref = await SharedPreferences.getInstance();
    try{
     UserCredential userCredential = await   _auth.createUserWithEmailAndPassword(email: emailId, password: userPassword);
        await userCredential.user!.sendEmailVerification();
     await pref.setString("name", userName);
     await pref.setString("email", emailId);
     await pref.setString("pass", userPassword);
     await pref.setBool("isLogin", true);
     Fluttertoast.showToast(msg: "Register Success");
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeTabBarScreens()), (Route<dynamic> route) => false,);
      clearController();
    }catch(e){
      Fluttertoast.showToast(msg:"Register failed $e");
    }
  }

  Future<void> loginNow({
    required BuildContext context,
    required String emailId,
    required String userPassword,
  }) async {
    final pref = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailId,
        password: userPassword,
      );

      if (userCredential.user!.emailVerified) {
        Fluttertoast.showToast(msg: "Please verify your email before login.");
        await _auth.signOut();
        return;
      }
      await pref.setBool('isLogin', true);
       pref.getString('email');
       pref.getString('pass');

      Fluttertoast.showToast(msg: "Login Success");
      AppRoot.appRoutRemoveUntil(
        context: context,
        page: const HomeTabBarScreens(),
      );

      clearController();
    } catch (e) {
      Fluttertoast.showToast(msg: "Login failed: $e");
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const UserRegistationScreen(),));

      Fluttertoast.showToast(msg: "LogOut successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Logout failed $e");
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
          msg: "Password reset link sent to $email");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to send reset link: $e");
    }
  }
  void clearController(){
    userName.clear();
    emailIdController.clear();
    userPasswordController.clear();
  }

}