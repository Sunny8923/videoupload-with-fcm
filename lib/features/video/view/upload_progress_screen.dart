import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/video_viewmodel.dart';

class UploadProgressScreen extends ConsumerWidget {
  final File videoFile;
  const UploadProgressScreen({super.key, required this.videoFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(videoViewModelProvider);

    Future.microtask(() async {
      if (!uploadState.uploading && uploadState.progress == 0) {
        await ref.read(videoViewModelProvider.notifier).uploadVideo(videoFile);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Uploading...')),
      body: Center(
        child: uploadState.uploading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(value: uploadState.progress),
                  const SizedBox(height: 20),
                  Text(
                    '${(uploadState.progress * 100).toStringAsFixed(0)}% uploaded',
                  ),
                ],
              )
            : uploadState.success
            ? const Text('✅ Upload Successful!')
            : Text('❌ Failed: ${uploadState.error ?? 'Unknown error'}'),
      ),
    );
  }
}
