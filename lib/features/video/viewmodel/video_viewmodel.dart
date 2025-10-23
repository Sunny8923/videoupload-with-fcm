import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_upload_with_fcm/features/video/data/video_repository.dart';

class VideoUploadState {
  final double progress;
  final bool uploading;
  final bool success;
  final String? error;

  const VideoUploadState({
    this.progress = 0.0,
    this.uploading = false,
    this.success = false,
    this.error,
  });

  VideoUploadState copyWith({
    double? progress,
    bool? uploading,
    bool? success,
    String? error,
  }) {
    return VideoUploadState(
      progress: progress ?? this.progress,
      uploading: uploading ?? this.uploading,
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }
}

class VideoViewModel extends Notifier<VideoUploadState> {
  late final VideoRepository _repo;

  @override
  VideoUploadState build() {
    _repo = VideoRepository();
    return const VideoUploadState();
  }

  Future<void> uploadVideo(File file) async {
    state = state.copyWith(uploading: true, progress: 0, success: false);

    try {
      await _repo.uploadVideo(
        file,
        onSendProgress: (sent, total) {
          final double progress = total > 0 ? sent / total : 0;
          state = state.copyWith(progress: progress);
        },
      );

      state = state.copyWith(uploading: false, success: true, progress: 1.0);
    } catch (e) {
      state = state.copyWith(uploading: false, error: e.toString());
    }
  }
}

final videoViewModelProvider =
    NotifierProvider<VideoViewModel, VideoUploadState>(VideoViewModel.new);
