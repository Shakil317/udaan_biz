import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycalculator/Utils/app_dialog.dart';
import 'package:mycalculator/Utils/app_them.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../Utils/about_app.dart';
import '../ViewModels/auth_service.dart';
import 'forgot_password_screen.dart';
import 'home_tab_bar_screen.dart';

class UserRegistationScreen extends StatefulWidget {
  const UserRegistationScreen({super.key});

  @override
  State<UserRegistationScreen> createState() => _UserRegistationScreenState();
}

class _UserRegistationScreenState extends State<UserRegistationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
 late AuthService registerProvider;
 late TextEditingController emailCon = TextEditingController();
 late TextEditingController passCon = TextEditingController();

  @override
  void initState() {
    AboutApp.enableScreenshot();
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            registerProvider.clearController();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    registerProvider.clearController();
  }
  @override
  Widget build(BuildContext context) {
    registerProvider = Provider.of<AuthService>(context,listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: AppThem.appBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/udaan_biz_logo.png"),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.black,
                        indicatorColor: AppThem.appSecondaryColor,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: "Login"),
                          Tab(text: "Sign Up"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                              ),
                              child: buildLoginTab(),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                              ),
                              child: buildSignupTab(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildLoginTab() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
          child: TextField(
            controller: emailCon,
            autofillHints: Characters(AutofillHints.email),
            autocorrect: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email_outlined),
              hintText: "Email",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
          child: TextField(
            controller: passCon,
            autocorrect: true,
            autofillHints: Characters(AutofillHints.newPassword),
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              hintText: "Password",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 35.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                AppDialog.navigatePage(context, const ForgotPasswordScreen());
              },
              child: const Text("Forgot Password?"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                  registerProvider.loginNow(
                      context: context,
                      emailId: emailCon.text
                          .toString(),
                      userPassword: passCon.text.toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThem.appSecondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        const Text("Or continue with"),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            SizedBox(width: 280,
              height: 45,
              child:SignInButton(
                Buttons.google,
                text: "Sign up with Google",
                onPressed: () async{
                  bool? isLogged = await registerProvider.signInWithGoogle();
                        if (isLogged == true) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeTabBarScreens()),
                          );
                        } else {
                          Fluttertoast.showToast(msg: "Google Login Failed");
                        }
                },
              ) ,),
          ],
        ),
      ],
    );
  }

  Widget buildSignupTab() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
          child: TextField(
            controller: registerProvider.userName,
            autofillHints: Characters(AutofillHints.name),
            autocorrect: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline),
              hintText: "Full Name",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
          child: TextField(
            controller: registerProvider.emailIdController,
            autocorrect: true,
            autofillHints: Characters(AutofillHints.email),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              hintText: "Email",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
          child: TextField(
            controller: registerProvider.userPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              hintText: "Password",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                var name = registerProvider.userName.text.toString();
                var email = registerProvider.emailIdController.text.toString();
                var password = registerProvider.userPasswordController.text.toString();
                if (name.isNotEmpty && email.isNotEmpty  && password.isNotEmpty ) {
                  registerProvider.registerNow(context: context, userName: name, emailId: email, userPassword: password);
                } else {
                  Fluttertoast.showToast(
                      msg: "please fill in all blanks");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThem.appSecondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
