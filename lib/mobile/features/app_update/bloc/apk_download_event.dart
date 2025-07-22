part of 'apk_download_bloc.dart';

sealed class ApkDownloadEvent extends Equatable {
  const ApkDownloadEvent();

  @override
  List<Object> get props => [];
}

class ApkDownloadUpdateProgress extends ApkDownloadEvent {
  final int? progress;
  const ApkDownloadUpdateProgress(this.progress);
}
