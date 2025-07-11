abstract class ActionStateEnum implements Enum {
  String get nameString;
}

enum MuteState implements ActionStateEnum {
  mute,
  notMuted,
  toggle;

  @override
  String get nameString {
    switch (this) {
      case MuteState.mute:
        return 'Mute';
      case MuteState.notMuted:
        return 'Not Mute';
      case MuteState.toggle:
        return 'Toggle';
    }
  }

  bool get isMute => this == MuteState.mute;
  bool get isNotMute => this == MuteState.notMuted;
  bool get isToggle => this == MuteState.toggle;

  static MuteState fromString(String value) {
    for (final state in MuteState.values) {
      if (state.name == value) return state;
    }
    return MuteState.toggle;
  }
}
