import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../ViewModels/reals_view_provider.dart';
import '../ViewModels/status_view_provider.dart';
import '../ViewModels/user_profile_provider.dart';
import '../models/ststus_view_model.dart';

class StatusViewScreen extends StatefulWidget {
  const StatusViewScreen({super.key});

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileProvider>(context, listen: false)
          .showProfileData();
      Provider.of<StatusViewProvider>(context, listen: false).loadMedia();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StatusViewProvider>(
        builder: (context, mediaProvider, _) {
          if (mediaProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (mediaProvider.mediaList.isEmpty) {
            return const Center(child: Text("No Media Found"));
          }
          return ListView.builder(
            itemCount: mediaProvider.mediaList.length,
            itemBuilder: (ctx, i) {
              final media = mediaProvider.mediaList[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: MediaCard(media: media),
              );
            },
          );
        },
      ),
    );
  }
}

class MediaCard extends StatefulWidget {
  final StatusViewModel media;

  const MediaCard({super.key, required this.media});

  @override
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard>
    with TickerProviderStateMixin {
  late RealsViewProvider statusProvider;

  @override
  void initState() {
    super.initState();
    statusProvider = Provider.of<RealsViewProvider>(context, listen: false);
    statusProvider.initMedia(widget.media);
    statusProvider.initAnimation(this);
    Future.delayed(const Duration(seconds: 16), () {
      statusProvider.stopAnimation();
    });
  }

  @override
  void dispose() {
    Provider.of<RealsViewProvider>(context, listen: false).disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusProvider = Provider.of<RealsViewProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    final prov =
    profileProvider.userProfile.isNotEmpty
        ? profileProvider.userProfile.first
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (statusProvider.isVideo)
                    statusProvider.initialized
                        ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: statusProvider
                            .videoController!.value.size.width,
                        height: statusProvider
                            .videoController!.value.size.height,
                        child: VideoPlayer(
                            statusProvider.videoController!),
                      ),
                    )
                        : const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (statusProvider.isAudio)
                    Center(
                      child: IconButton(
                        iconSize: 60,
                        color: Colors.white,
                        icon: Icon(statusProvider.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle),
                        onPressed: () {
                          statusProvider
                              .toggleAudio(widget.media.mediaUrl);
                        },
                      ),
                    )
                  else
                    Image.network(
                      widget.media.mediaUrl,
                      fit: BoxFit.cover,
                    ),
                  Positioned(
                    top: 35,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                widget.media.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black87,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Status",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 30,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          prov?.shopName ?? '${prov?.bankInfo}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "✨ की तरफ से होली एवं ईद की ✨\n✨ हार्दिक शुभकामनाएँ! ✨",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: statusProvider.moveController,
                      builder: (_, __) {
                        return Align(
                          alignment: statusProvider.stopAtCenter
                              ? Alignment.center
                              : statusProvider.moveAnimation.value,
                          child: Transform.scale(
                            scale:
                            statusProvider.scaleAnimation.value,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: prov?.profileImage != null
                                  ? FileImage(
                                  File(prov!.profileImage!))
                                  : const AssetImage(
                                  "assets/images/udaan_biz_logo.png")
                              as ImageProvider,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black45,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                      Icons.download, "Download", _download),
                  _actionButton(Icons.share, "Share", _share),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Future<void> _download() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) return;
    }

    statusProvider.startDownload();

    final uri = Uri.parse(widget.media.mediaUrl);
    final response = await http.Client().send(http.Request('GET', uri));
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/${widget.media.name}.mp4');
    final sink = file.openWrite();

    int received = 0;
    final total = response.contentLength ?? 0;

    await for (final chunk in response.stream) {
      sink.add(chunk);
      received += chunk.length;
      statusProvider.updateProgress(received / total);
    }

    await sink.close();
    statusProvider.finishDownload(file.path);
  }

  Future<void> _share() async {
    if (statusProvider.downloadedFilePath == null) return;
    await Share.shareXFiles(
        [XFile(statusProvider.downloadedFilePath!)]);
  }
}