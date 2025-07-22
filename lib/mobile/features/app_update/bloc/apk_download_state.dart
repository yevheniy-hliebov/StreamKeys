part of 'apk_download_bloc.dart';

class ApkDownloadState extends Equatable {
  final int? progress;

  const ApkDownloadState([this.progress]);

  @override
  List<Object?> get props => [progress];
}
