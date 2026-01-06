import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/app_them.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late TextEditingController emailController;
  var perfLogin =   SharedPreferences.getInstance();

  @override
  void initState() {
    emailController = TextEditingController(text: user?.email ?? "");
    super.initState();
  }

  Future<void> sendPasswordReset() async {
    if (emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter email");
      return;
    }
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Fluttertoast.showToast(
          msg: "Password reset link sent to ${emailController.text}");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🔹 Title
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 User Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: AppThem.appSecondaryColor,
                backgroundImage: user?.photoURL != null ?
                NetworkImage(user!.photoURL!) :
                null, child: user?.photoURL == null ?
              Text(user?.email?[0].toUpperCase() ?? "?", style: const
              TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold,),)
                  : null,),

              const SizedBox(height: 16),

              /// 🔹 Info Text
              Text(
                "Enter your email address to reset your password\n\nYour registered email: ${user?.email ?? " "}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 25),

              /// 🔹 Email Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.orange),
                  hintText: "Enter Email",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// 🔹 Reset Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThem.appBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    sendPasswordReset();
                  },
                  child: const Text(
                    "Send Reset Link",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
