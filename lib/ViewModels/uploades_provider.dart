import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class UploaderProvider with ChangeNotifier{
  final FirebaseStorage storage = FirebaseStorage.instance;
  final DatabaseReference database = FirebaseDatabase.instance.ref("status");
  final TextEditingController statusTextController = TextEditingController();

  File? pickedFile;
  bool isVideo = false;
  bool isUploading = false;
  VideoPlayerController? videoController;

  Future<void> pickMedia(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickMedia();
    if (picked != null) {
      final file = File(picked.path);
    notifyListeners();
        pickedFile = file;
        isVideo = picked.path.toLowerCase().endsWith('.mp4') ||
            picked.mimeType?.contains('video') == true;
        if (isVideo) {
        videoController?.dispose();
        videoController = VideoPlayerController.file(pickedFile!)
          ..initialize().then((_) {
           notifyListeners();
            videoController!.play();
          });
      }
    }
  }
  Future<void> uploadToFirebase(BuildContext context) async {
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file first')),
      );
      return;
    }
     isUploading = true;
    notifyListeners();
    try {
      final fileName = "status_${DateTime.now().millisecondsSinceEpoch}${isVideo ? ".mp4" : ".jpg"}";
      final ref = storage.ref().child('uploads/$fileName');
      await ref.putFile(pickedFile!);
      final url = await ref.getDownloadURL();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploaded Successfully \n$fileName')),
      );

        pickedFile = null;
        videoController?.dispose();
        isVideo = false;
    notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed:$e')),
      );
    } finally {
       isUploading = false;
       notifyListeners();
    }
  }

}