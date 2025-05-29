class DeckPagesData {
  String currentPage;
  List<String> orderPages;

  DeckPagesData({
    required this.currentPage,
    required this.orderPages,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckPagesData &&
          runtimeType == other.runtimeType &&
          currentPage == other.currentPage &&
          orderPages == other.orderPages;

  @override
  int get hashCode => currentPage.hashCode ^ orderPages.hashCode;
}
