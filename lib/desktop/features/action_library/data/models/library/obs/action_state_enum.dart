abstract class ActionStateEnum implements Enum {
  String get nameString;
}

mixin ActionStateMixin<T extends Enum> implements ActionStateEnum {
  bool isState(T state) => this == state;

  static T fromString<T extends Enum>(List<T> values, String value) {
    for (final state in values) {
      if (state.name == value) return state;
    }
    return values.last;
  }
}

enum MuteState with ActionStateMixin<MuteState> implements ActionStateEnum {
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

  bool get isMute => isState(MuteState.mute);
  bool get isNotMute => isState(MuteState.notMuted);
  bool get isToggle => isState(MuteState.toggle);

  static MuteState fromString(String value) {
    return ActionStateMixin.fromString(MuteState.values, value);
  }
}

enum VisibilityState
    with ActionStateMixin<VisibilityState>
    implements ActionStateEnum {
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

  bool get isHidden => isState(VisibilityState.hidden);
  bool get isVisible => isState(VisibilityState.visible);
  bool get isToggle => isState(VisibilityState.toggle);

  static VisibilityState fromString(String value) {
    return ActionStateMixin.fromString(VisibilityState.values, value);
  }
}

enum ProcessState
    with ActionStateMixin<ProcessState>
    implements ActionStateEnum {
  start,
  stop,
  toggle;

  @override
  String get nameString {
    switch (this) {
      case ProcessState.start:
        return 'Start';
      case ProcessState.stop:
        return 'Stop';
      case ProcessState.toggle:
        return 'Toggle';
    }
  }

  bool get isStart => isState(ProcessState.start);
  bool get isStop => isState(ProcessState.stop);
  bool get isToggle => isState(ProcessState.toggle);

  static ProcessState fromString(String value) {
    return ActionStateMixin.fromString(ProcessState.values, value);
  }
}
