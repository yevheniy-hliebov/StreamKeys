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

enum VisibilityState implements ActionStateEnum {
  hidden,
  visible,
  toggle;

  @override
  String get nameString {
    switch (this) {
      case VisibilityState.hidden:
        return 'Hidden';
      case VisibilityState.visible:
        return 'Visible';
      case VisibilityState.toggle:
        return 'Toggle';
    }
  }

  bool get isHidden => this == VisibilityState.hidden;
  bool get isVisible => this == VisibilityState.visible;
  bool get isToggle => this == VisibilityState.toggle;

  static VisibilityState fromString(String value) {
    for (final state in VisibilityState.values) {
      if (state.name == value) return state;
    }
    return VisibilityState.toggle;
  }
}
