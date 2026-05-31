import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycalculator/calculator_screens/calculator_screen.dart';
import 'package:mycalculator/screens/real_account_home_page.dart';
import 'package:mycalculator/screens/setting_screen.dart';
import 'package:mycalculator/screens/status_view_home.dart';
import 'package:mycalculator/screens/user_screens.dart';
import 'package:provider/provider.dart';
import '../Utils/about_app.dart';
import '../Utils/app_dialog.dart';
import '../Utils/app_roots.dart';
import '../Utils/app_them.dart';
import '../ViewModels/auth_service.dart';
import '../ViewModels/user_profile_provider.dart';
import 'generate_item_list.dart';

class HomeTabBarScreens extends StatefulWidget {
   const HomeTabBarScreens({super.key});
  @override
  State<HomeTabBarScreens> createState() => _HomeTabBarScreensState();
}
class _HomeTabBarScreensState extends State<HomeTabBarScreens> {
  late UserProfileProvider profileProvider;
  @override
  void initState() {
    AboutApp.enableScreenshot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
     profileProvider = Provider.of<UserProfileProvider>(context,listen: false);
    return
      DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar:
        AppBar(
          backgroundColor: AppThem.appBgColor,
          leading: Consumer<UserProfileProvider>(
            builder: (context, value, child) {
              final hasProfile = value.userProfile.isNotEmpty;
              final item = hasProfile ? value.userProfile[0] : null;
              final hasProfileImage = hasProfile &&
                  item!.profileImage != null &&
                  item.profileImage!.isNotEmpty;
              ImageProvider<Object>? avatarImage;
              if (hasProfileImage) {
                avatarImage = item.profileImage!.startsWith('assets/')
                    ? AssetImage(item.profileImage!)
                    : FileImage(File(item.profileImage!));
              } else if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
                avatarImage = NetworkImage(user.photoURL!);
              } else {
                avatarImage = null;
              }
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 2.0),
                child: GestureDetector(
                  onDoubleTap: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RealAccountHomePage(),), (route) => false,);
                    Fluttertoast.showToast(msg: "Switch to New Account");
                  },
                  onTap: () async {
                    await AppDialog.myProfileDialog(context);
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppThem.appTextColor,
                      backgroundImage: avatarImage,
                      child: avatarImage == null
                          ? Text((user?.displayName?.isNotEmpty ?? false)
                            ? user!.displayName![0].toUpperCase()
                            : (user?.email?.isNotEmpty ?? true)
                            ? user!.email![0].toUpperCase()
                            : '?',
                        style:  TextStyle(
                          color: AppThem.appTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
          title: Consumer<UserProfileProvider>(
            builder: (context, value, child) {
              var profile = value.userProfile;
              if (profile.isEmpty) {
                return Text(
                  formatText(user!.displayName.toString(), 20),
                  style:  TextStyle(fontSize: 21, color: AppThem.appTextColor),
                  overflow: TextOverflow.ellipsis,
                );
              }
              final item = profile[0];
              return Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatText(item.shopName ?? "ABC Store", 20),
                      style:  TextStyle(
                        fontSize: 21,
                        color: AppThem.appTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 10,
                          backgroundImage: AssetImage(
                            "assets/images/udaan_biz_logo.png",
                          ),
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RealAccountHomePage(),), (route) => false,);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const RealAccountHomePage(),));
                              Fluttertoast.showToast(msg: "Switch to Login Account");
                            },
                           // user!.email
                            child: Text("${"dummyaccount@udaanbiz.com"} ᐯ", style:  TextStyle(fontSize: 12, color: AppThem.appTextColor,),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                AppDialog.navigatePage(
                    context,
                    const SettingScreen());
              },
              icon:  Icon(Icons.settings, color: AppThem.appTextColor),
            ),
          ],

          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Customer"),
              Tab(text: "Calculator"),
              Tab(text: "Billing"),
            ],
          ),
        ),
        body:  const TabBarView(
          children: [
            UserScreens(),
            CalculateScreen(),
            GenerateItemListScreen(),
          ],
        ),
      ),
    );
  }

   String formatText(String text, int maxCharsPerLine) {
     List<String> lines = [];
     for (int i = 0; i < text.length; i += maxCharsPerLine) {
       int end = (i + maxCharsPerLine < text.length)
           ? i + maxCharsPerLine
           : text.length;
       lines.add(text.substring(i, end));
     }
     return lines.join('\n');
   }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2),() {
      const UserScreens();
    },);
  }
}
