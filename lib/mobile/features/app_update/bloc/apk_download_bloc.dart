import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/service_locator.dart';

part 'apk_download_event.dart';
part 'apk_download_state.dart';

class ApkDownloadBloc extends Bloc<ApkDownloadEvent, ApkDownloadState> {
  final AppUpdateService appUpdateService;

  ApkDownloadBloc(this.appUpdateService) : super(const ApkDownloadState()) {
    appUpdateService.githubUpdater.downloader.downloadProgressStream.listen((
      progress,
    ) {
      add(ApkDownloadUpdateProgress(progress));
    });

    on<ApkDownloadUpdateProgress>((event, emit) {
      emit(ApkDownloadState(event.progress));
    });
  }
}
