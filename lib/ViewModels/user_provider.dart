import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mycalculator/Utils/app_dialog.dart';
import 'package:mycalculator/screens/home_tab_bar_screen.dart';
import 'package:uuid/uuid.dart';
import '../models/users_model.dart';
import '../screens/user_contact.dart';
import 'contact_provider.dart';
import 'database_helper.dart';

class UserProvider with ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<UsersModel> filteredUsers = [];
  XFile? image;
  List<UsersModel> users = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final LocalAuthentication localAuth = LocalAuthentication();

  UserProvider() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    searchUsers(searchController.text.trim());
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      filteredUsers = List.from(users);
    } else {
      filteredUsers = users.where((user) {
        return user.name!.toLowerCase().contains(query.toLowerCase()) ||
            user.number!.contains(query);
      }).toList();
    }
    notifyListeners();
  }

  void addToListUser() {
    DatabaseHelper().getUser().then((value) {
      users.addAll(value.map((user) => UsersModel.fromMap(user)).toList());
      notifyListeners();
    });
  }

  void insertNewUser(BuildContext context) async {
    String userId = const Uuid().v4();
    String? imagePath = image?.path;
    var addUser = {
      "userId_321": userId.replaceAll('-', ' ').substring(0, 6),
      "image": imagePath,
      "name": nameController.text.trim(),
      "number": numberController.text.trim(),
    };

    await DatabaseHelper().insertUser(addUser);
    Fluttertoast.showToast(
        msg: 'Add New User Success ${numberController.text.trim()}');
    showData();
    notifyListeners();
  }

  void deleteUser(BuildContext context, int index) async {
    await DatabaseHelper().deleteUser(users[index].id!);
    Navigator.pop(context);
    showData();
    notifyListeners();
  }

  void showData() async {
    users.clear();
    List<Map<String, dynamic>> userList = await DatabaseHelper().getUser();
    users.addAll(userList.map((user) => UsersModel.fromMap(user)).toList());
    filteredUsers = List.from(users);
    notifyListeners();
  }

  Future<void> pickNewImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
    } else {
      Fluttertoast.showToast(msg: "No Image Selected");
    }
    notifyListeners();
  }
  Future<void> pickNewImageWithCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = pickedFile;
    } else {
      Fluttertoast.showToast(msg: "No Image Selected");
    }
    notifyListeners();
  }


  Future<void> addNewUserWithFilter(
      BuildContext context, ContactProvider contactProvider) async {
    String enteredName = nameController.text.trim();
    String enteredPhoneNumber = numberController.text.trim();

    if (enteredName.isNotEmpty && enteredPhoneNumber.isNotEmpty) {
      bool isPhoneNumberExist = contactProvider.contacts.any((contact) =>
          contact.phones.any((phone) =>
              phone.number.replaceAll(RegExp(r'\D'), '') ==
              enteredPhoneNumber));
      bool isNameExist = contactProvider.contacts.any((contact) =>
          contact.displayName.toLowerCase() == enteredName.toLowerCase());

      if (isPhoneNumberExist || isNameExist) {
        Fluttertoast.showToast(
            msg: "This phone number or name already exists. Please Search");
        AppDialog.navigatePage(context, const UserContact());
      } else {
        insertNewUser(context);
        Navigator.pop(context);
        clearController();
      }
    } else {
      Fluttertoast.showToast(msg: "Please fill all fields.");
    }
  }

  void checkLocalAuthUpdate(BuildContext context, UsersModel userModel) async {
    bool isAvailable = await localAuth.canCheckBiometrics;
    Fluttertoast.showToast(msg: "is Available");

    if (isAvailable) {
      bool results = await localAuth.authenticate(
        localizedReason: "Scan Your Finger Print to Proceed",
        options: const AuthenticationOptions(useErrorDialogs: true),
      );
      if (results) {
        if (userModel.id == null) {
          Fluttertoast.showToast(msg: "Invalid user ID");
          return;
        }
        var updateData = {
          "name": nameController.text.trim(),
          "number": numberController.text.trim(),
        };
        if (image != null) {
          updateData["image"] = image!.path;
        } else if (userModel.image != null) {
          updateData["image"] = userModel.image!;
        }
        DatabaseHelper().updateUser(updateData, userModel.id!);
        Fluttertoast.showToast(msg: "User updated successfully");
        showData();
        AppDialog.navigatePage(context, const HomeTabBarScreens());
        clearController();
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: "Permission Denied");
      }
    } else {
      Fluttertoast.showToast(msg: "No Biometric sensor detected");
    }
  }

  void checkLocalAuthAndDeleteUser(BuildContext context, int index) async {
    bool isAvailable = await localAuth.canCheckBiometrics;
    Fluttertoast.showToast(msg: "is Available");
    if (isAvailable) {
      bool results = await localAuth.authenticate(
        localizedReason: "Scan Your Finger Print to Proceed",
        options: const AuthenticationOptions(useErrorDialogs: true),
      );
      if (results) {
        DatabaseHelper().deleteUser(filteredUsers[index].id!);
        showData();
      } else {
        Fluttertoast.showToast(msg: "Permission Denied");
      }
    } else {
      Fluttertoast.showToast(msg: "No Biometric sensor detected");
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    clearController();
    super.dispose();
  }

  void clearController() {
    nameController.clear();
    numberController.clear();
    image = null;
  }
}
