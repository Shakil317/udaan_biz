import 'package:flutter/material.dart';
import 'package:mycalculator/ViewModels/contact_provider.dart';
import 'package:mycalculator/Utils/app_dialog.dart';
import 'package:provider/provider.dart';
import '../Utils/about_app.dart';
import '../Utils/app_them.dart';
import 'home_tab_bar_screen.dart';

class UserContact extends StatefulWidget {
    const UserContact({super.key,});

  @override
  State<UserContact> createState() => _UserContactState();
}

class _UserContactState extends State<UserContact>
    with SingleTickerProviderStateMixin {
  late AnimationController searchAnimationController;

  @override
  void initState() {
    var contactProvider = Provider.of<ContactProvider>(context, listen: false);
    AboutApp.enableScreenshot();
    super.initState();
    contactProvider.searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    contactProvider.searchAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: contactProvider.searchAnimationController,
        curve: Curves.easeInOut));

    contactProvider.getContactPermission();

    contactProvider.searchController.addListener(() {
      contactProvider.searchContactsByName();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContactProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white70,
          size: 18,
        ),
        title: provider.isSearching
            ? SlideTransition(
                position: provider.searchAnimation,
                child: TextField(
                  autocorrect: true,
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                  cursorColor: Colors.white70,
                  cursorHeight: 20.0,
                  textInputAction: TextInputAction.next,
                  cursorWidth: 3.0,
                  cursorRadius: const Radius.circular(5.0),
                  controller: provider.searchController,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    fillColor: Colors.white70,
                    iconColor: Colors.white70,
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.white,
                        )),
                    hintStyle: const TextStyle(
                      color: Colors.white60,
                      fontSize: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              )
            : const Text(
                "User Contact",
                style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
        backgroundColor: const Color(0xFF1d2630),
        actions: [
          IconButton(
            onPressed: provider.toggleSearch,
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent))
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppThem.appBgColor, AppThem.appBgColor],
                ),
              ),
              child: ListView.builder(
                itemCount: provider.contacts.length,
                itemBuilder: (context, index) {
                  var contact = provider.contacts[index];
                  var contactAvatar =
                      contact.photo != null && contact.photo!.isNotEmpty
                          ? MemoryImage(contact.photo!)
                          : null;
                  String phoneNumber =
                      provider.contacts[index].phones.isNotEmpty
                          ? provider.contacts[index].phones.first.number
                          : 'No phone number';
                  return ListTile(
                    onTap:() {
                     //AppDialogBox.navigatePage(context, UserScreens(name: provider.contacts[index].displayName.toString(),result: provider.contacts[index].phones.toString(),));
                    } ,
                    title: Text(
                       provider.contacts[index].displayName,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(
                       phoneNumber,
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 15),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 20,
                      backgroundImage: contactAvatar,
                      child: contactAvatar == null
                          ? Center(
                              child: Text(
                                  contact.displayName.isNotEmpty
                                      ? contact.displayName[0]
                                      : "?",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            )
                          : null,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        provider.addContactByIndex(index);
                        //AppDialog.navigatePage(context, const HomeTabBarScreens());

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeTabBarScreens()),
                              (Route<dynamic> route) => false,
                        );
                        },
                      child: Container(
                        height: 30,
                        color: const Color(0xFF1d2630),
                        width: 40,
                        child: const Center(
                          child: Text(
                            "Invite",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         AppDialog.createNewUserDialog(context);
        },
        label: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }
}
