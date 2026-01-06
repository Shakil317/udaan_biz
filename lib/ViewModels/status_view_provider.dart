import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/ststus_view_model.dart';

class StatusViewProvider with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<StatusViewModel> _mediaList = [];
  bool _isLoading = false;

  List<StatusViewModel> get mediaList => _mediaList;
  bool get isLoading => _isLoading;

  Future<void> loadMedia() async {
    _isLoading = true;
    notifyListeners();

    try {
      _mediaList = await fetchMediaList();
    } catch (e) {
      debugPrint("Error in MediaProvider: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<StatusViewModel>> fetchMediaList() async {
    List<StatusViewModel> mediaList = [];
    try {
      final ref = _storage.ref().child('/uploads');
      final result = await ref.listAll();

      for (var item in result.items) {
        final url = await item.getDownloadURL();
        final name = item.name.toLowerCase();

        String type = "image";
        if (name.endsWith('.mp4') || name.endsWith('.mov') || name.endsWith('.avi')) {
          type = "video";
        } else if (name.endsWith('.mp3') || name.endsWith('.wav') || name.endsWith('.m4a')) {
          type = "audio";
        }

        mediaList.add(StatusViewModel(
          mediaUrl: url,
          name: item.name.split('.').first,
          phone: 'N/A',
          type: type,
        ));
      }
    } catch (e) {
      debugPrint("Error fetching media: $e");
    }
    return mediaList;
  }
}
