part of 'hidmacros_bloc.dart';

class HidMacrosState extends Equatable {
  final List<KeyboardDevice> keyboards;
  final KeyboardDevice? selectedKeyboard;
  final KeyboardType? selectedKeyboardType;
  final HidMacrosStartupOptions options;
  final bool autoStart;
  final bool isLoading;

  final KeyboardDevice? savedKeyboard;
  final KeyboardType? savedKeyboardType;
  final HidMacrosStartupOptions savedOptions;
  final bool savedAutoStart;

  const HidMacrosState({
    this.keyboards = const [],
    this.selectedKeyboard,
    this.selectedKeyboardType,
    this.options = const HidMacrosStartupOptions(),
    this.autoStart = false,
    this.isLoading = false,
    this.savedKeyboard,
    this.savedKeyboardType,
    this.savedOptions = const HidMacrosStartupOptions(),
    this.savedAutoStart = false,
  });

  bool get hasChanges =>
      autoStart != savedAutoStart ||
      options != savedOptions ||
      selectedKeyboard != savedKeyboard ||
      selectedKeyboardType != savedKeyboardType;

  HidMacrosState copyWith({
    List<KeyboardDevice>? keyboards,
    KeyboardDevice? selectedKeyboard,
    KeyboardType? selectedKeyboardType,
    HidMacrosStartupOptions? options,
    bool? autoStart,
    bool? isLoading,
    KeyboardDevice? savedKeyboard,
    KeyboardType? savedKeyboardType,
    HidMacrosStartupOptions? savedOptions,
    bool? savedAutoStart,
  }) {
    return HidMacrosState(
      keyboards: keyboards ?? this.keyboards,
      selectedKeyboard: selectedKeyboard ?? this.selectedKeyboard,
      selectedKeyboardType: selectedKeyboardType ?? this.selectedKeyboardType,
      options: options ?? this.options,
      autoStart: autoStart ?? this.autoStart,
      isLoading: isLoading ?? this.isLoading,
      savedKeyboard: savedKeyboard ?? this.savedKeyboard,
      savedKeyboardType: savedKeyboardType ?? this.savedKeyboardType,
      savedOptions: savedOptions ?? this.savedOptions,
      savedAutoStart: savedAutoStart ?? this.savedAutoStart,
    );
  }

  @override
  List<Object?> get props => [
    keyboards,
    selectedKeyboard,
    selectedKeyboardType,
    options,
    autoStart,
    isLoading,
    savedKeyboard,
    savedKeyboardType,
    savedOptions,
    savedAutoStart,
  ];
}
