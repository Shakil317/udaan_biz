import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'database_helper.dart';

class ContactProvider with ChangeNotifier {
  late AnimationController searchAnimationController;
  late Animation<Offset> searchAnimation;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> newUsers = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController givenController = TextEditingController();
  TextEditingController familyController = TextEditingController();

  List<Contact> contacts = [];
  bool isLoading = true;

  void toggleSearch() {
    isSearching = !isSearching;
    if (isSearching) {
      searchAnimationController.forward();
    } else {
      searchAnimationController.reverse();
      searchController.clear();
    }
    notifyListeners();
  }

  void loadFirstContactDetails() {
    if (contacts.isNotEmpty) {
      final contact = contacts.first;

      givenController.text = contact.name.first ?? '';
      familyController.text = contact.name.last ?? '';
      emailController.text = contact.emails.isNotEmpty ? contact.emails.first.address : '';
    }
    notifyListeners();
  }

  void getContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      fetchContact();
    } else {
      Fluttertoast.showToast(msg: 'Contacts permission denied');
    }
    notifyListeners();
  }

  void fetchContact() async {
    isLoading = true;
    contacts = await FlutterContacts.getContacts(withProperties: true,withPhoto: true);
    contacts = contacts.where((contact) {
      return contact.phones.isNotEmpty &&
          contact.phones.any((phone) => _isValidPhoneNumber(phone.number));
    }).toList();
    isLoading = false;
    notifyListeners();
  }

  bool _isValidPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null) return false;
    var cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return cleaned.length == 10 &&
        !phoneNumber.contains('*') &&
        !phoneNumber.contains('#') &&
        !phoneNumber.contains('+');
  }

  void addToListDataBase() {
    DatabaseHelper().getUser().then((value) {
      newUsers.addAll(value);
      notifyListeners();
    });
  }

  void addToUserList(String contactName, String userContactNumber, String userId) async {
    var addUser = {
      "name": contactName,
      "number": userContactNumber,
      "userId_321": userId.replaceAll('-', ' ').substring(0, 6),
    };
    await DatabaseHelper().insertUser(addUser);
    showData();
  }

  void addContactByIndex(int index) async {
    if (index >= 0 && index < contacts.length) {
      var contact = contacts[index];
      String givenName = contact.displayName;
      String userId = const Uuid().v4();
      for (var phone in contact.phones) {
        if (_isValidPhoneNumber(phone.number)) {
          addToUserList(givenName, phone.number, userId);
        }
      }
      Fluttertoast.showToast(msg: 'Contact Added: $givenName');
    }
  }

  void showData() async {
    newUsers.clear();
    newUsers = await DatabaseHelper().getUser();
    notifyListeners();
  }

  void searchContactsByName() {
    String searchQuery = searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      contacts = contacts.where((contact) {
        String name = contact.displayName.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    } else {
      fetchContact();
    }
    notifyListeners();
  }
}
