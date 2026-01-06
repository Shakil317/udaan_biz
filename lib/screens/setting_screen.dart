import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycalculator/Utils/app_roots.dart';
import 'package:mycalculator/screens/special_card_screen.dart';
import 'package:mycalculator/screens/tamplete_screen.dart';
import 'package:mycalculator/screens/user_registation_screen.dart';
import 'package:provider/provider.dart';
import '../Utils/about_app.dart';
import '../ViewModels/user_provider.dart';
import '../ViewModels/user_profile_provider.dart';
import '../ViewModels/transition_history_provider.dart';

class SettingScreen extends StatefulWidget {
  final int? id;
  final String? name;
  final String? userData;

  const SettingScreen({super.key, this.id, this.name, this.userData});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late UserProvider userProvider;
  late UserProfileProvider userProfileProvider;
  late TransitionHistoryProvider creditProvider;
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    AboutApp.enableScreenshot();
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    creditProvider = Provider.of<TransitionHistoryProvider>(context, listen: false);

    userProvider.showData();
    userProfileProvider.showProfileData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      creditProvider.showAmountTransition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final profileData = Provider.of<UserProfileProvider>(context);
    final transitionData = Provider.of<TransitionHistoryProvider>(context);

    return Scaffold(
      body: Consumer<UserProfileProvider>(
        builder: (context, profileData, child) {
          var profile = profileData.userProfile;
          return Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0),
            child: ListView.builder(
              itemCount: profile.length,
              itemBuilder: (context, index) {
                final item = profile[index];
                final hasImage = item.profileImage != null && item.profileImage!.isNotEmpty;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                      child: Text(
                        formatText("Settings", 20),
                        style: const TextStyle(fontSize: 28, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white,
                              foregroundImage: hasImage
                                  ? (item.profileImage!.startsWith('assets/')
                                  ? AssetImage(item.profileImage!)
                                  : FileImage(File(item.profileImage!))) as ImageProvider
                                  : const AssetImage('assets/images/main_home_image.jpeg'),
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5, right: 2),
                                child: Text(
                                  formatText(item.shopName ?? "ABC Store", 20),
                                  style: const TextStyle(fontSize: 21, color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 12,
                                    backgroundImage: AssetImage("assets/images/udaan_biz_logo.png"),
                                  ),
                                  Text(
                                    user!.email ?? "user@example.com",
                                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: const Text(
                          "More Options",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text("Logout"),
                            onTap: ()  {
                              AppRoot.appAlertDialog(context: context, title: "LogOut", contentMes: "Are you sure you want to logout?", buttonText: "LogOut", toastMes: "LogOut Success", onConfirm: ()async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRegistationScreen(),));
                              },);
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.share),
                            title: const Text("Share App"),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Share feature coming soon!")),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text("About App"),
                            onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  const SpecialCardScreen(),));
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: const Text(
                          "App Features",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          ListTile(
                            leading: const Icon(Icons.card_giftcard, color: Colors.red),
                            title: const Text("Use Template"),
                            onTap: ()  {
                             
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTemplateListScreen(id: 0,),));
                              
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.generating_tokens_sharp),
                            title: const Text("Generated Bill"),
                            onTap: () {

                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text("About App"),
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: "UdaanBiz App",
                                applicationVersion: "1.0.0",
                                children: const [
                                  Text("This app helps you manage your store and customers efficiently."),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
  String formatText(String text, int maxCharsPerLine) {
    List<String> lines = [];
    for (int i = 0; i < text.length; i += maxCharsPerLine) {
      int end = (i + maxCharsPerLine < text.length) ? i + maxCharsPerLine : text.length;
      lines.add(text.substring(i, end));
    }
    return lines.join('\n');
  }
  Future<bool> showConfirmationDialog(
      BuildContext context, String title, String content) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Logout"),
          ),
        ],
      ),
    ) ?? false;
  }
}
