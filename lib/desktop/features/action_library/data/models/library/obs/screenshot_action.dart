import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action_icons.dart';
import 'package:streamkeys/desktop/features/action_library/presentation/widgets/forms/screenshot_action_form.dart';
import 'package:streamkeys/desktop/utils/file_manager.dart';
import 'package:streamkeys/desktop/utils/sound_service.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:uuid/uuid.dart';

extension DurationExtensions on Duration {
  String toSecondsString({int fractionDigits = 1}) {
    return (inMilliseconds / 1000).toStringAsFixed(fractionDigits);
  }

  static Duration getDelayFromDouble(double seconds) {
    return Duration(
      milliseconds: (seconds * 1000).round(),
    );
  }
}

class ScreenshotAction extends BindingAction {
  final String recordingPath;
  final Duration delay;
  final bool playSound;
  final SoundService _soundService;
  final FileManager _fileManager;

  ScreenshotAction({
    String? id,
    this.recordingPath = 'C:/Screenshots',
    this.delay = Duration.zero,
    this.playSound = false,
    SoundService? soundService,
    FileManager fileManager = const FileManager(),
  })  : _soundService = soundService ?? SoundService(),
        _fileManager = fileManager,
        super(
          id: id ?? const Uuid().v4(),
          type: ActionTypes.obsScreenshot,
          name: 'Screenshot',
        );

  @override
  String get dialogTitle => 'Set Screenshot Delay';

  @override
  String get label {
    if (delay == Duration.zero) {
      return 'OBS | $name';
    } else {
      return 'OBS | $name (delay: ${delay.toSecondsString(fractionDigits: 2)}s)';
    }
  }

  @override
  Widget getIcon(BuildContext context) {
    return BindingActionIcons.of(context).obsScreenshot;
  }

  @override
  Json toJson() {
    return {
      'type': type,
      'recording_path': recordingPath,
      'delay': delay.inSeconds.toString(),
      'play_sound': playSound,
    };
  }

  factory ScreenshotAction.fromJson(Json json) {
    final delay = int.parse(json['delay'] as String);
    return ScreenshotAction(
      recordingPath: json['recording_path'] ?? '',
      delay: Duration(seconds: delay),
      playSound: json['play_sound'] as bool? ?? false,
    );
  }

  @override
  BindingAction copy() {
    return ScreenshotAction(
      recordingPath: recordingPath,
      delay: delay,
      playSound: playSound,
    );
  }

  @override
  Future<void> execute({Object? data}) async {
    final obs = sl<ObsService>().obs;
    if (obs == null) return;

    try {
      await _soundService.countdownTick(delay, playSound: playSound);

      final currentScene = await obs.scenes.getCurrentProgramScene();

      final result = await obs.sources.getSourceScreenshot(
        SourceScreenshot(
          sourceName: currentScene,
          imageFormat: 'jpeg',
          imageWidth: 1920,
          imageHeight: 1080,
        ),
      );

      final base64Str = result.imageData.split(',').last;
      final bytes = _fileManager.decodeBase64Image(base64Str);

      await _fileManager.saveScreenshot(
        bytes: bytes,
        fileNamePart: currentScene,
      );

      if (playSound) {
        await _soundService.playShutter();
      }
    } catch (e, s) {
      if (kDebugMode) {
        print('$e\n$s');
      }
    }
  }

  @override
  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdated,
  }) {
    return ScreenshotActionForm(
      initialAction: this,
      onUpdated: (newValue) {
        onUpdated?.call(newValue);
      },
      fileManager: _fileManager,
    );
  }

  @override
  List<Object?> get props => [id, type, name, delay];
}
