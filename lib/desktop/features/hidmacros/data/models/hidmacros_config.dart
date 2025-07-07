import 'package:equatable/equatable.dart';

class HidMacrosConfig extends Equatable {
  final bool autoStart;
  final bool minimizeToTray;
  final bool startMinimized;

  const HidMacrosConfig({
    this.autoStart = false,
    this.minimizeToTray = false,
    this.startMinimized = false,
  });

  HidMacrosConfig copyWith({
    bool? autoStart,
    bool? minimizeToTray,
    bool? startMinimized,
  }) {
    return HidMacrosConfig(
      autoStart: autoStart ?? this.autoStart,
      minimizeToTray: autoStart ?? this.minimizeToTray,
      startMinimized: autoStart ?? this.startMinimized,
    );
  }

  @override
  List<Object?> get props => [autoStart, minimizeToTray, startMinimized];
}
