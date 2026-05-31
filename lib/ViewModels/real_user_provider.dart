import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import '../Utils/app_dialog.dart';
import '../Utils/app_them.dart';
import '../models/real_user_model.dart';
import '../screens/user_contact.dart';

class RealUserProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userProfile');
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child("Customers");
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<RealUserModel> _userList = [];

  List<RealUserModel> get userList => _userList;
  final LocalAuthentication localAuth = LocalAuthentication();


  final nameController = TextEditingController();
  final phoneNumController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  File? pickedImages;

  File? get pickedImage => pickedImages;
  late bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  Future<String?> uploadImageToFirebase(String id) async {
    if (pickedImages == null) return null;
    final uid = _auth.currentUser?.uid;
    final ref = _storage.ref().child("profile/$uid/$id.jpg");
    await ref.putFile(pickedImages!);
    final imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }
  void createUserDialog(BuildContext context) {
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
                  side: BorderSide(
                    width: 3,
                    color: AppThem.appSecondaryColor,
                    style: BorderStyle.solid,
                  ),
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Add New Customer",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThem.appSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        pickImage(ImageSource.gallery);

                      },
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.redAccent,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: pickedImage == null
                              ? const AssetImage(
                              "assets/images/udaan_biz_logo.png")
                              : FileImage(File(pickedImage!.path)),
                          backgroundColor: AppThem.appBgColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextField(
                        controller: nameController,
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
                          labelStyle: TextStyle(color: AppThem.appBgColor),
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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 4),
                          child: SizedBox(
                            width: 200,
                            height: 70,
                            child: TextField(
                              maxLength: 12,
                              controller: phoneNumController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: AppThem.appBgColor),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                                labelText: "Enter  Number",
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
                            AppDialog.navigatePage(context, const UserContact());
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
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        width: 350,
                        height: 50,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppThem.appBgColor,
                            ),
                          ),
                          onPressed: () async {
                            if(nameController.text.isNotEmpty || phoneNumController.text.isNotEmpty){
                              setLoading(true);
                              await addUserToRealtime();
                              clearInputs();
                              setLoading(false);
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: "User Added Successfully!");
                              notifyListeners(); // rebuild UI
                            }else{
                              Fluttertoast.showToast(msg: "Please Fill in Blanks");
                            }

                          },
                          child: isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
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



  Future<void> pickImage(ImageSource source) async {
    final picked =
        await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (picked != null) {
      pickedImages = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> addUserToRealtime() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        Fluttertoast.showToast(msg: "User not logged in");
        return;
      }
      final newRef = _dbRef.child(uid).push();
      final id = newRef.key!;

      final imageUrl = await uploadImageToFirebase(id);
      final newUser = RealUserModel(
        id: id,
        name: nameController.text.trim(),
        phone: phoneNumController.text.trim(),
        imageUrl: imageUrl,
        finalCollection:double.tryParse(amountController.text.trim()) ?? 0.0,
      );
      await newRef.set(newUser.toMap());
      clearInputs();
      await fetchUsers();
    } catch (e) {
      debugPrint("Error adding user: $e");
    }
  }

  Future<void> fetchUsers() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    _dbRef.child(uid).onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      _userList.clear();
      if (data != null) {
        data.forEach((key, value) {
          final user = RealUserModel.fromMap(Map<String, dynamic>.from(value));
          _userList.add(user);
        });
      }
       notifyListeners();
    });
  }

  Future<void> updateUserInRealtime(RealUserModel user) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;
      String? imageUrl = user.imageUrl;
      if (pickedImages != null) {
        imageUrl = await uploadImageToFirebase(user.id);
      }

      final updatedUser = RealUserModel(
        id: user.id,
        name: nameController.text.trim(),
        phone: phoneNumController.text.trim(),
        imageUrl: imageUrl,
        finalCollection:user.finalCollection,
      );
      await _dbRef.child(uid).child(user.id).update(updatedUser.toMap());
      clearInputs();
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating user: $e");
    }
  }
  void clearInputs() {
    nameController.clear();
    phoneNumController.clear();
    amountController.clear();
    pickedImages = null;
  }
  void checkLocalAuthAndDeleteRealUser(BuildContext context,String id) async {
    bool isAvailable = await localAuth.canCheckBiometrics;
    Fluttertoast.showToast(msg: "is Available");
    if (isAvailable) {
      bool results = await localAuth.authenticate(
        localizedReason: "Scan Your Finger Print to Proceed",
        options: const AuthenticationOptions(useErrorDialogs: true),
      );
      if (results){
        try {
          final uid = _auth.currentUser?.uid;
          if (uid == null) return;
          await _dbRef.child(uid).child(id).remove();
          Fluttertoast.showToast(msg: "Delete  User Success");
          notifyListeners();
        } catch (e) {
          debugPrint("Error deleting user: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Permission Denied");
      }
    } else {
      Fluttertoast.showToast(msg: "No Biometric sensor detected");
    }
  }
}
