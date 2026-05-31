import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mycalculator/Utils/app_roots.dart';
import 'package:mycalculator/screens/real_transition_history_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/app_them.dart';
import '../ViewModels/real_user_provider.dart';
import '../ViewModels/user_profile_provider.dart';
import '../models/real_user_model.dart';

class RealUsersScreen extends StatefulWidget {
  const RealUsersScreen({super.key});

  @override
  State<RealUsersScreen> createState() => _RealUsersScreenState();
}

class _RealUsersScreenState extends State<RealUsersScreen> {
  late UserProfileProvider profileProvider;
  @override
  void initState() {
    super.initState();
    Provider.of<RealUserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProfileProvider>(context, listen: false).showProfileData();
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppThem.appBgColor,
          onPressed: () {
            final provider = Provider.of<RealUserProvider>(context,listen: false);
            provider.createUserDialog(context);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body:Consumer<RealUserProvider>(builder: (context, data, child) {
          final users = data.userList;
          return users.isEmpty
              ? const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(
                    Colors.deepOrangeAccent),),
                SizedBox(height: 10,),
                Text(
                  "No Users Found",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          )
              : ListView.builder(
            itemCount: users.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RealTransitionHistoryScreen(
                        number: user.phone,
                        totalAmount: 52,
                        imagePr: user.imageUrl,
                        id: user.id.toString(),
                        name: user.name,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.grey[50],
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8,),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      leading: CircleAvatar(
                        radius: 27,
                        backgroundColor:Colors.orange.shade100,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: user.imageUrl != null
                              ? NetworkImage(user.imageUrl!)
                              : const AssetImage(
                              "assets/images/udaan_biz_logo.png")
                          as ImageProvider,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM -yy').format(DateTime.now()),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              user.phone,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          //
                          Text(
                            "₹ ${user.finalCollection.toString()}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: user.finalCollection <= 0
                                  ? Colors.green
                                  : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        color: Colors.white,
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditDialog(context, data, user);
                          } else if (value == 'delete') {
                            AppRoot.appAlertDialog(context: context, title: "Delete User", contentMes: "Are You Sure You Want To Delete ${user.name}?", buttonText: "Yes", toastMes: "Delete Success", onConfirm: () {
                              data.checkLocalAuthAndDeleteRealUser(context, user.id);
                            },);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit, color: Colors.blue),
                              title: Text("Edit"),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text("Delete"),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Connect With WhatApp',
                            child: ListTile(
                              leading: const Icon(Icons.chat, color: Colors.green),
                              title: const Text("Connect With WhatApp"),
                              onTap: () async{
                                String presetMessage =
                                    "नमस्ते ${user.name}, आपकी वर्तमान बकाया राशि ${user.finalCollection ?? '00'}₹ है। कृपया सुनिश्चित करें कि भुगतान 7 दिनों के भीतर कर दिया जाए, ताकि क्रेडिट सेवाएं बिना किसी रुकावट के जारी रह सकें। ${profileProvider.userProfile[0].shopName}🙏";
                                final sms = Uri.parse(
                                    'sms:${user.phone.toString()}?body=${Uri.encodeComponent(presetMessage)}');
                                if (await canLaunchUrl(sms)) {
                                  launchUrl(sms);
                                }
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
                                    "नमस्ते ${user.name}, आपकी वर्तमान बकाया राशि ${user.finalCollection ?? '00'}₹ है। कृपया सुनिश्चित करें कि भुगतान 7 दिनों के भीतर कर दिया जाए, ताकि क्रेडिट सेवाएं बिना किसी रुकावट के जारी रह सकें। ${profileProvider.userProfile[0].shopName}🙏";
                                final sms = Uri.parse(
                                    'sms:${user.phone.toString()}?body=${Uri.encodeComponent(presetMessage)}');
                                if (await canLaunchUrl(sms)) {
                                  launchUrl(sms);
                                }
                                Navigator.pop(context);
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
          );
        },),
      );

  }
  void _showEditDialog(
      BuildContext context, RealUserProvider provider, RealUserModel user) {
    provider.nameController.text = user.name;
    provider.phoneNumController.text = user.phone;
    provider.pickedImages = null;
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(
                    width: 3,
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Edit User",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThem.appSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        provider.pickImage(ImageSource.gallery);
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: provider.pickedImage == null
                            ? (user.imageUrl != null
                                ? NetworkImage(user.imageUrl!)
                                : const AssetImage(
                                        "assets/images/udaan_biz_logo.png")
                                    as ImageProvider)
                            : FileImage(File(provider.pickedImage!.path)),
                        backgroundColor: AppThem.appBgColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextField(
                        controller: provider.nameController,
                        decoration: const InputDecoration(
                          labelText: "Enter Your Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextField(
                        maxLength: 12,
                        controller: provider.phoneNumController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Enter Mobile Number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        width: 350,
                        height: 50,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppThem.appBgColor),
                          ),
                          onPressed: () async {
                            await provider.updateUserInRealtime(user);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Update",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
