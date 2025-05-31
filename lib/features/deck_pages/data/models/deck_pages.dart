class DeckPagesData {
  String currentPage;
  List<String> orderPages;

  DeckPagesData({
    required this.currentPage,
    required this.orderPages,
  });

  DeckPagesData copy() {
    return DeckPagesData(
      currentPage: currentPage,
      orderPages: orderPages,
    );
  }
}
