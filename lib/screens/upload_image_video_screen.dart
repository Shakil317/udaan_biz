import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../ViewModels/uploades_provider.dart';

class UploadImageVideoScreen extends StatefulWidget {
  const UploadImageVideoScreen({super.key});

  @override
  State<UploadImageVideoScreen> createState() => _UploadImageVideoScreenState();
}

class _UploadImageVideoScreenState extends State<UploadImageVideoScreen> {
  late UploaderProvider uploaderProvider;

  @override
  void dispose() {
    uploaderProvider = Provider.of<UploaderProvider>(context, listen: true);
    uploaderProvider.videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    uploaderProvider = Provider.of<UploaderProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(6),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(2, 4))
                  ],
                ),
                child: uploaderProvider.pickedFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                uploaderProvider.pickMedia(ImageSource.gallery),
                            child: const Icon(Icons.cloud_upload,
                                size: 80, color: Colors.green),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Select Image or Video to Upload",
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: uploaderProvider.isVideo
                            ? uploaderProvider.videoController != null &&
                                    uploaderProvider
                                        .videoController!.value.isInitialized
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: uploaderProvider
                                            .videoController!.value.aspectRatio,
                                        child: VideoPlayer(
                                            uploaderProvider.videoController!),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          uploaderProvider.videoController!
                                                  .value.isPlaying
                                              ? Icons.pause_circle
                                              : Icons.play_circle_fill,
                                          color: Colors.white70,
                                          size: 60,
                                        ),
                                        onPressed: () {
                                          if (uploaderProvider.videoController!
                                              .value.isPlaying) {
                                            uploaderProvider.videoController!
                                                .pause();
                                          } else {
                                            uploaderProvider.videoController!.play();
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: CircularProgressIndicator())
                            : Image.file(
                                uploaderProvider.pickedFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                      ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Choose Option:",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          uploaderProvider.pickMedia(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white70,
                      ),
                      label: const Text(
                        "Gallery",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => uploaderProvider.isUploading
                          ? null
                          : uploaderProvider.uploadToFirebase(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: uploaderProvider.isUploading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.cloud_upload,
                              color: Colors.white70,
                            ),
                      label: Text(
                        uploaderProvider.isUploading
                            ? "Uploading..."
                            : "Upload",
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
