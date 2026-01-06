import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mycalculator/ViewModels/user_profile_provider.dart';
import 'package:mycalculator/screens/tamplete_screen.dart';
import 'package:mycalculator/screens/user_contact.dart';
import 'package:mycalculator/screens/user_screens.dart';
import 'package:provider/provider.dart';
import 'app_them.dart';
import '../ViewModels/contact_provider.dart';
import '../ViewModels/database_helper.dart';
import '../ViewModels/transition_history_provider.dart';
import '../ViewModels/user_provider.dart';
import '../calculator_screens/calculator_screen.dart';

class AppDialog {
  static void navigatePage(BuildContext context, var pageName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageName,
        ));
  }
  static Future<void> myProfileDialog(BuildContext context) async {
    var profileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    await profileProvider.showProfileData();
    if (profileProvider.userProfile.isNotEmpty) {
      profileProvider.shopNameController.text =
          profileProvider.userProfile[0].shopName ?? '';
      profileProvider.phoneController.text =
          profileProvider.userProfile[0].phone ?? '';
      profileProvider.bankInfoController.text =
          profileProvider.userProfile[0].bankInfo ?? '';
      profileProvider.qrImage =
          XFile(profileProvider.userProfile[0].qrImage ?? '');
      profileProvider.prImage =
          XFile(profileProvider.userProfile[0].profileImage ?? '');
      profileProvider.stampImage =
          XFile(profileProvider.userProfile[0].uploadStamp ?? '');
    }
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<UserProfileProvider>(
          builder: (context, value, child) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom * 0.6),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6 + 30,
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(width: 3, color: Colors.orange),
                    ),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Text("Edit Your Profile",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppThem.appSecondaryColor)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: TextField(
                            controller: value.shopNameController,
                            keyboardType: TextInputType.name,
                            maxLength: 25,
                            style: const TextStyle(color: AppThem.appBgColor),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              labelText: "Enter Your Shop / Company / Name",
                              labelStyle: TextStyle(color: AppThem.appBgColor),
                              prefixIcon:
                                  Icon(Icons.person, color: AppThem.appBgColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: TextField(
                            controller: value.phoneController,
                            keyboardType: TextInputType.name,
                            maxLength: 12,
                            style: const TextStyle(color: AppThem.appBgColor),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              labelText: "Enter Your Phone or Email",
                              labelStyle:
                                  TextStyle(color: AppThem.appSecondaryColor),
                              prefixIcon: const Icon(Icons.person,
                                  color: AppThem.appBgColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: TextField(
                            controller: value.bankInfoController,
                            keyboardType: TextInputType.name,
                            maxLength: 42,
                            style: const TextStyle(color: AppThem.appBgColor),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              labelText: "Enter Your Address/ Shop Info",
                              labelStyle: TextStyle(color: AppThem.appBgColor),
                              prefixIcon:
                                  Icon(Icons.person, color: AppThem.appBgColor),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                value.pickNewImage("profile");
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.orangeAccent,
                                                width: 1),
                                            color: Colors.green),
                                        child: Image(
                                          image: value.prImage == null
                                              ? const AssetImage(
                                                  "assets/images/Profile_image.png")
                                              : FileImage(
                                                  File(value.prImage!.path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Upload Profile",
                                      style: TextStyle(
                                          color: AppThem.appSecondaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                value.pickNewImage('stamp');
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.orangeAccent,
                                                width: 1)),
                                        child: Image(
                                          image: value.stampImage == null
                                              ? const AssetImage(
                                                  "assets/images/shop_keeper_image.jpg")
                                              : FileImage(
                                                  File(value.stampImage!.path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Upload Stamp",
                                      style: TextStyle(
                                          color: AppThem.appSecondaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                value.pickNewImage('qr');
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.orangeAccent,
                                                width: 1)),
                                        child: Image(
                                          image: value.qrImage == null
                                              ? const AssetImage(
                                                  "assets/images/dumi_scaner_image.jpg")
                                              : FileImage(
                                                  File(value.qrImage!.path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Upload QR",
                                      style: TextStyle(
                                          color: AppThem.appSecondaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: SizedBox(
                            width: 350,
                            height: 50,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppThem.appBgColor)),
                              onPressed: () async {
                                var name = profileProvider
                                    .shopNameController.text
                                    .toString();
                                var number = profileProvider
                                    .phoneController.text
                                    .toString();
                                var shopInfo = profileProvider
                                    .bankInfoController.text
                                    .toString();
                                var qrImage =
                                    profileProvider.qrImage.toString();
                                var prImage =
                                    profileProvider.userProfile.toString();
                                if (name.isNotEmpty &&
                                    number.isNotEmpty &&
                                    shopInfo.isNotEmpty &&
                                    qrImage.isNotEmpty &&
                                    prImage.isNotEmpty) {
                                  value.createOrUpdateProfile(context);
                                  profileProvider.clearController();
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "please fill in all blanks");
                                }
                              },
                              child: Text(
                                  profileProvider.isProfileExist
                                      ? "Update"
                                      : "Save",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
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
      },
    );
  }

  static Future<void> updateProfile(BuildContext context, int profileId) async {
    var profileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    final profile = {
      'shopName': profileProvider.shopNameController.text.trim(),
      'phone': profileProvider.phoneController.text.trim(),
      'bankInfo': profileProvider.bankInfoController.text.trim(),
      'qrImage': profileProvider.qrImage?.path ?? '',
      'profileImage': profileProvider.prImage?.path ?? '',
      'uploadStamp': profileProvider.stampImage?.path ?? '',
    };

    int result =
        await DatabaseHelper().updateMyProfile(profile, profileId.toString());

    if (result > 0) {
      Fluttertoast.showToast(msg: "Profile Updated Successfully");
      profileProvider.showProfileData();
    } else {
      Fluttertoast.showToast(msg: "Fail to  Updated Profile Data");
    }
  }

  static void createNewUserDialog(BuildContext context) {
    var contactProvider = Provider.of<ContactProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<UserProvider>(
          builder: (context, usersData, child) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5 + 10,
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                          width: 3, color: AppThem.appSecondaryColor),
                    ),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 20),
                          child: Text("Add New User",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppThem.appSecondaryColor)),
                        ),
                         SizedBox(height: 10),
                        InkWell(
                          onLongPress: () {
                            usersData.pickNewImageWithCamera();
                          },
                          onTap: () {
                            usersData.pickNewImage();
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: usersData.image != null
                                ? FileImage(File(usersData.image!.path))
                                : const AssetImage(
                                    "assets/images/Profile_image.png"),
                            backgroundColor: AppThem.appBgColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child:
                                TextField(
                                  controller: usersData.nameController,
                                  keyboardType: TextInputType.name,
                                  style: const TextStyle(
                                      color: AppThem.appBgColor),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    labelText: "Enter Name",
                                    labelStyle:
                                        TextStyle(color: AppThem.appBgColor),
                                    prefixIcon: Icon(Icons.person,
                                        color: AppThem.appBgColor),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 4),
                              child: SizedBox(
                                width: 200,
                                height: 70,
                                child: TextField(
                                  maxLength: 12,
                                  controller: usersData.numberController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                      color: AppThem.appBgColor),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    labelText: "Enter Phone Number",
                                    labelStyle:
                                        TextStyle(color: AppThem.appBgColor),
                                    prefixIcon: Icon(Icons.phone,
                                        color: AppThem.appBgColor),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            FloatingActionButton.extended(
                              backgroundColor: AppThem.appBgColor,
                              onPressed: () {
                                AppDialog.navigatePage(context, UserContact());
                              },
                              label: const Row(
                                children: [
                                  Icon(
                                    Icons.contact_page,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Contact",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: SizedBox(
                            width: 350,
                            height: 50,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppThem.appBgColor)),
                              onPressed: () {
                                usersData.addNewUserWithFilter(
                                    context, contactProvider);
                              },
                              child: const Text("Save",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
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
      },
    );
  }

  static void createUserDialog(BuildContext context) {
    var provider = Provider.of<ContactProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(
                      width: 3, color: Colors.orange, style: BorderStyle.solid),
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 20),
                          child: Text(
                            "Add New User",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppThem.appSecondaryColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        userProvider.pickNewImage();
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: userProvider.image == null
                            ? const AssetImage("assets/images/shakilansari.jpg")
                            : FileImage(File(userProvider.image!.path)),
                        backgroundColor: AppThem.appBgColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextField(
                        controller: userProvider.nameController,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(
                          color: AppThem.appBgColor,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(
                              color: AppThem.appBgColor,
                              width: 2,
                            ),
                          ),
                          labelText: "Enter Your Name",
                          fillColor: AppThem.appBgColor,
                          labelStyle: TextStyle(color: Colors.orange),
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppThem.appBgColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: AppThem.appBgColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextField(
                        autocorrect: true,
                        maxLength: 12,
                        controller: userProvider.numberController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: AppThem.appBgColor),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 2,
                                style: BorderStyle.solid),
                          ),
                          labelText: "Enter Mobile Number",
                          fillColor: AppThem.appBgColor,
                          labelStyle: TextStyle(color: AppThem.appBgColor),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppThem.appBgColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: AppThem.appBgColor,
                              width: 2,
                            ),
                          ),
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
                                  WidgetStatePropertyAll(AppThem.appBgColor)),
                          onPressed: () {
                            var name =
                                userProvider.nameController.text.toString();
                            var number =
                                userProvider.numberController.text.toString();
                            if (name.isNotEmpty && number.isNotEmpty) {
                              String enteredName =
                                  userProvider.nameController.text.trim();
                              String enteredPhoneNumber =
                                  userProvider.numberController.text.trim();
                              bool isPhoneNumberExist =
                                  provider.contacts.any((contact) {
                                return contact.phones.any((phone) =>
                                    phone.number == enteredPhoneNumber);
                              });
                              bool isNameExist =
                                  provider.contacts.any((contact) {
                                return contact.displayName == enteredName;
                              });
                              if (isPhoneNumberExist || isNameExist) {
                                Fluttertoast.showToast(
                                    msg:
                                        "This phone number or name already exists in this contact list.");
                              } else {
                                userProvider.insertNewUser(context);
                                AppDialog.navigatePage(
                                    context, const UserScreens());
                                Fluttertoast.showToast(
                                    msg: "Add New User Success.");
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please fill in all fields.");
                            }
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Save",
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

  static void amountUpdateDialog(
    BuildContext context, {
    required String dialogTitle,
    required TextEditingController controllerType,
    required String states,
  }) {
    var creditProvider = Provider.of<TransitionHistoryProvider>(
      context,
      listen: false,
    );
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
                  side: const BorderSide(width: 3, color: Colors.orange),
                ),
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 20),
                      child: Text(
                        dialogTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppThem.appBgColor,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 55, top: 10),
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              maxLength: 5,
                              controller: controllerType,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppThem.appBgColor),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: "Enter amount here",
                                hintText: "Enter amount here",
                                hintStyle: TextStyle(color: AppThem.appBgColor),
                                labelStyle:
                                    TextStyle(color: AppThem.appBgColor),
                                prefixIcon: Icon(Icons.currency_rupee,
                                    color: AppThem.appBgColor),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            AppDialog.navigatePage(
                                context, const CalculateScreen());
                          },
                          icon: const Icon(
                            Icons.calculate,
                            color: AppThem.appBgColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, bottom: 10),
                          child: SizedBox(
                            width: 160,
                            height: 45,
                            child: TextField(
                              controller: creditProvider.dateController,
                              keyboardType: TextInputType.datetime,
                              style: const TextStyle(color: AppThem.appBgColor),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: "Current Date",
                                hintText: DateFormat('dd-MM-yyyy')
                                    .format(DateTime.now()),
                                hintStyle:
                                    const TextStyle(color: AppThem.appBgColor),
                                labelStyle:
                                    const TextStyle(color: AppThem.appBgColor),
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    creditProvider.selectedDate(context);
                                  },
                                  icon: const Icon(
                                    Icons.date_range,
                                    color: AppThem.appBgColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 150,
                          height: 45,
                          child: TextField(
                            controller: creditProvider.timeController,
                            keyboardType: TextInputType.datetime,
                            style: const TextStyle(color: AppThem.appBgColor),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              labelText: "Current Time",
                              hintText:
                                  DateFormat('hh:mm a').format(DateTime.now()),
                              hintStyle:
                                  const TextStyle(color: AppThem.appBgColor),
                              labelStyle:
                                  const TextStyle(color: AppThem.appBgColor),
                              prefixIcon: IconButton(
                                onPressed: () {
                                  creditProvider.selectedTime(context);
                                },
                                icon: const Icon(
                                  Icons.more_time_rounded,
                                  color: AppThem.appBgColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: SizedBox(
                            width: 250,
                            child: TextField(
                              maxLength: 25,
                              controller:
                                  creditProvider.productRemarkController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(color: AppThem.appBgColor),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: "Remark Item",
                                hintText: "Remark Item",
                                hintStyle: TextStyle(color: AppThem.appBgColor),
                                labelStyle:
                                    TextStyle(color: AppThem.appBgColor),
                                prefixIcon: Icon(
                                  Icons.production_quantity_limits,
                                  color: AppThem.appBgColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            AppDialog.navigatePage(
                                context,
                                const AdminTemplateListScreen(
                                  id: null,
                                ));
                          },
                          icon: const Icon(
                            Icons.shopping_bag_sharp,
                            color: AppThem.appBgColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                          onPressed: () {
                            if (controllerType.text.isNotEmpty ||
                                creditProvider
                                    .productRemarkController.text.isNotEmpty) {
                              creditProvider.insertNewTransition(
                                context,
                                status: states.toString(),
                              );
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please fill in Amount and Remark");
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
