import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'preview_video_screen.dart';

class RecordVideoScreen extends StatelessWidget {
  const RecordVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Video')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final picker = ImagePicker();
            final picked = await picker.pickVideo(source: ImageSource.camera);
            if (picked != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PreviewVideoScreen(videoFile: File(picked.path)),
                ),
              );
            }
          },
          child: const Text('🎥 Record Video'),
        ),
      ),
    );
  }
}
