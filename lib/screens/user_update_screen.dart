import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycalculator/Utils/app_roots.dart';
import 'package:mycalculator/Utils/app_them.dart';
import 'package:provider/provider.dart';
import '../Utils/about_app.dart';
import '../ViewModels/contact_provider.dart';
import '../ViewModels/user_provider.dart';
import '../models/users_model.dart';

class UpdateUserScreen extends StatefulWidget {
  final UsersModel user;
  const UpdateUserScreen({super.key, required this.user});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  late ContactProvider contactProvider;

  @override
  void initState() {
    AboutApp.enableScreenshot();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      contactProvider = Provider.of<ContactProvider>(context, listen: false);
        contactProvider.loadFirstContactDetails();
      showUsers();
      contactProvider.showData();
    });
  }

  void showUsers() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.nameController.text = widget.user.name ?? '';
    provider.numberController.text = widget.user.number ?? '';
    if (widget.user.image != null) {
      provider.image = XFile(widget.user.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    contactProvider = Provider.of<ContactProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update User"),
        centerTitle: true,
        backgroundColor: AppThem.appBarColor,
        foregroundColor: AppThem.appTextColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onLongPress: () => userProvider.pickNewImage(),
              onTap: () => userProvider.pickNewImageWithCamera(),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.orange.shade100,
                backgroundImage: userProvider.image != null
                    ? FileImage(File(userProvider.image!.path))
                    : widget.user.image != null
                    ? FileImage(File(widget.user.image!))
                    : null,
                child: (userProvider.image == null && widget.user.image == null)
                    ? const Icon(Icons.camera_alt, size: 40, color: AppThem.appBarColor)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: userProvider.nameController,
                      label: "Personal Name",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: contactProvider.givenController,
                      label: "Given Name",
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: userProvider.numberController,
                      label: "Contact Number",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: contactProvider.emailController,
                      label: "Email Address",
                      icon: Icons.email,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: contactProvider.familyController,
                      label: "Family Name",
                      icon: Icons.group,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  AppRoot.appAlertDialog(
                    context: context,
                    title: "User Update",
                    contentMes: "Are you sure you want to update ${widget.user.name}?",
                    buttonText: "Update",
                    toastMes: "Update Success",
                    onConfirm: () {
                      userProvider.checkLocalAuthUpdate(context, widget.user);
                    },
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Update User", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThem.appBarColor,
                  foregroundColor:AppThem.appTextColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  /// Reusable styled text field
  Widget _buildTextField({
    required String label,
    IconData? icon,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppThem.appBarColor),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppThem.appBarColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
