import 'package:equatable/equatable.dart';

class HidMacrosStartupOptions extends Equatable {
  final bool minimizeToTray;
  final bool startMinimized;

  const HidMacrosStartupOptions({
    this.minimizeToTray = false,
    this.startMinimized = false,
  });

  HidMacrosStartupOptions copyWith({
    bool? minimizeToTray,
    bool? startMinimized,
  }) {
    return HidMacrosStartupOptions(
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
      startMinimized: startMinimized ?? this.startMinimized,
    );
  }

  @override
  List<Object?> get props => [minimizeToTray, startMinimized];
}
