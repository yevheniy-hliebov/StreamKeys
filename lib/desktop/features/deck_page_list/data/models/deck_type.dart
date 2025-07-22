enum DeckType { grid, keyboard }

extension DeckTypeExtension on DeckType {
  bool get isGrid => this == DeckType.grid;
  bool get isKeyboard => this == DeckType.keyboard;
}
