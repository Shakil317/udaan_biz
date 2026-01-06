import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/ststus_view_model.dart';

class RealsViewProvider with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;

  VideoPlayerController? videoController;
  AudioPlayer? audioPlayer;

  late AnimationController moveController;
  late Animation<Alignment> moveAnimation;
  late Animation<double> scaleAnimation;

  bool isVideo = false;
  bool isAudio = false;
  bool initialized = false;
  bool isPlaying = false;
  bool initFailed = false;
  bool stopAtCenter = false;

  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? downloadedFilePath;

  /// ---------------- MEDIA INIT ----------------
  Future<void> initMedia(StatusViewModel media) async {
    try {
      isVideo = media.type == "video";
      isAudio = media.type == "audio";

      if (isVideo) {
        videoController = VideoPlayerController.network(media.mediaUrl);
        await videoController!.initialize();
        videoController!
          ..setLooping(true)
          ..play();
        initialized = true;
      }

      if (isAudio) {
        audioPlayer = AudioPlayer();
      }

      notifyListeners();
    } catch (e) {
      initFailed = true;
      notifyListeners();
    }
  }

  /// ---------------- AUDIO PLAY / PAUSE ----------------
  Future<void> toggleAudio(String url) async {
    audioPlayer ??= AudioPlayer();

    if (isPlaying) {
      await audioPlayer!.pause();
    } else {
      await audioPlayer!.play(UrlSource(url));
    }
    isPlaying = !isPlaying;
    notifyListeners();
  }

  /// ---------------- ANIMATION ----------------
  void initAnimation(TickerProvider vsync) {
    moveController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    moveAnimation = Tween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(parent: moveController, curve: Curves.easeInOut),
    );

    scaleAnimation = Tween(begin: 0.8, end: 1.8).animate(
      CurvedAnimation(parent: moveController, curve: Curves.easeInOut),
    );
  }

  void stopAnimation() {
    stopAtCenter = true;
    moveController.stop();
    audioPlayer?.stop();
    videoController?.pause();
    notifyListeners();
  }

  /// ---------------- DOWNLOAD STATE ----------------
  void startDownload() {
    isDownloading = true;
    downloadProgress = 0;
    notifyListeners();
  }

  void updateProgress(double value) {
    downloadProgress = value;
    notifyListeners();
  }

  void finishDownload(String path) {
    downloadedFilePath = path;
    isDownloading = false;
    notifyListeners();
  }

  /// ---------------- DISPOSE ----------------
  void disposeAll() {
    videoController?.dispose();
    audioPlayer?.dispose();
    moveController.dispose();
  }
}
