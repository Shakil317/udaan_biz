import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:mycalculator/Utils/about_app.dart';
import 'package:mycalculator/Utils/app_roots.dart';
import 'package:mycalculator/ViewModels/user_profile_provider.dart';
import 'package:mycalculator/ViewModels/user_provider.dart';
import 'package:mycalculator/Utils/app_dialog.dart';
import 'package:mycalculator/screens/setting_screen.dart';
import 'package:mycalculator/screens/transition_history_screen.dart';
import 'package:mycalculator/screens/user_update_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Utils/app_them.dart';
import '../ViewModels/transition_history_provider.dart';

class UserScreens extends StatefulWidget {
  final int? id;
  final String? name;
  final String? userData;

  const UserScreens({super.key, this.id, this.name, this.userData});

  @override
  State<UserScreens> createState() => _UserScreensState();
}

class _UserScreensState extends State<UserScreens> {
  late UserProvider userProvider;
  late UserProfileProvider userProfileProvider;
  late TransitionHistoryProvider creditProvider;

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    AboutApp.enableScreenshot();
    super.initState();
    userProvider.showData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileProvider>(context, listen: false)
          .showProfileData();
      creditProvider =
          Provider.of<TransitionHistoryProvider>(context, listen: false);
      creditProvider.transitionList.clear();
      creditProvider.showAmountTransition();
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextField(
                  controller: value.searchController,
                  onChanged: (query) {
                    value.searchUsers(query);
                  },
                  cursorColor: AppThem.appBgColor,
                  style: const TextStyle(
                      fontSize: 14, color: AppThem.appBgColor),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search,
                        color: AppThem.appBgColor),
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.mic,)),
                    hintText: "Search User By Name....",
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: value.filteredUsers.isEmpty
                    ? const Center(
                  child: Text(
                    "No Users Found",
                    style:
                    TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: value.filteredUsers.length,
                  itemBuilder: (context, index) {
                    var user = value.filteredUsers[index];
                    var amount = double.tryParse(
                        user.userCollections ?? '0') ?? 0.0;

                    return GestureDetector(
                      onTap: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TransitionHistoryScreen(
                                    name: user.name,
                                    id: user.id,
                                    number: user.number.toString(),
                                    image: user.image,
                                    totalAmount: amount,
                                  ),
                            ));
                        if (result != "") {
                          Provider.of<UserProvider>(context,
                              listen: false)
                              .showData();
                        }
                      },
                      onLongPress: () {
                        AppRoot.appAlertDialog(
                          context: context,
                          title: "Delete User",
                          contentMes:
                          "Are you sure you want to delete User ${user.name}?",
                          buttonText: "Yes",
                          toastMes: "User Delete Success",
                          onConfirm: () {
                            value.checkLocalAuthAndDeleteUser(
                                context, index);
                          },
                        );
                      },
                      child:
                      Card(
                        color: Colors.grey[50],
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 8),
                          child: ListTile(
                            contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 5),
                            leading: InstaImageViewer(
                              child: CircleAvatar(
                                radius: 26,
                                backgroundColor:Colors.orange.shade400,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: (user.image != null && user.image!.isNotEmpty) ? FileImage(File(user.image!)) : null,
                                  child: (user.image == null || user.image!.isEmpty) ? Text(
                                    (user.name != null &&
                                        user.name!
                                            .isNotEmpty)
                                        ? user.name![0]
                                        .toUpperCase()
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  )
                                      : null,
                                ),
                              ),
                            ),

                            // 🔹 Title and Date
                            title: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user.name ?? widget.name!,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd MMM -yy').format(
                                          DateTime.now()),
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    user.number.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹ ${(user.userCollections?.toString().isNotEmpty ?? false) ? user.userCollections : '00'}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(Icons.call,
                                        color: AppThem.appBgColor),
                                    title: Text("Connect with Call",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppThem
                                                .appSecondaryColor)),
                                    onTap: () {
                                      launchUrlString(
                                          "tel://${user.number.toString()}");
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(Icons.share,
                                        color: AppThem.appBgColor),
                                    title: Text("WhatApp Chat",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppThem
                                                .appSecondaryColor)),
                                    onTap: () async {
                                      final sms = Uri.parse(
                                          'sms:${user.number.toString()}');
                                      if (await canLaunchUrl(sms)) {
                                        launchUrl(sms);
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(Icons.message,
                                        color: AppThem.appBgColor),
                                    title: Text("Message",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppThem
                                                .appSecondaryColor)),
                                    onTap: () async {
                                      String presetMessage =
                                          "नमस्ते ${user.name}, आपकी वर्तमान बकाया राशि ${user.userCollections ?? '00'}₹ है। कृपया सुनिश्चित करें कि भुगतान 10 दिनों के भीतर कर दिया जाए, ताकि क्रेडिट सेवाएं बिना किसी रुकावट के जारी रह सकें। ${userProfileProvider.userProfile[0].shopName}🙏";
                                      final sms = Uri.parse(
                                          'sms:${user.number.toString()}?body=${Uri.encodeComponent(presetMessage)}');
                                      if (await canLaunchUrl(sms)) {
                                        launchUrl(sms);
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(Icons.edit,
                                        color: AppThem.appBgColor),
                                    title: Text("Update",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppThem
                                                .appSecondaryColor)),
                                    onTap: () {
                                      AppDialog.navigatePage(
                                          context,
                                          UpdateUserScreen(user: user));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // 🔹 Floating Button
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          FloatingActionButton.extended(
            onPressed: () {
              AppDialog.createNewUserDialog(context);
              userProvider.clearController();
            },
            label: const Row(
              children: [
                Icon(Icons.add, color: Colors.white, size: 30),
                SizedBox(width: 5),
                Text('Add Person',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
            backgroundColor: AppThem.appSecondaryColor,
          ),
        ],
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
}
