class GridTemplate {
  final String type;
  final int numberOfColumns;
  final int numberOfRows;

  GridTemplate(
    this.numberOfColumns,
    this.numberOfRows, {
    this.type = 'Default',
  });

  int get totalCells => numberOfColumns * numberOfRows;

  Map<String, Object> toJson() {
    return <String, Object>{
      'type': type,
      'columns': numberOfColumns,
      'rows': numberOfRows,
    };
  }

  @override
  String toString() {
    return '${numberOfColumns}x$numberOfRows';
  }

  static GridTemplate fromJson(Map<String, dynamic> json) {
    return GridTemplate(
      json['columns'],
      json['rows'],
      type: json['type'],
    );
  }

  static List<GridTemplate> gridTemplates = <GridTemplate>[
    GridTemplate(3, 2, type: '3x2'),
    GridTemplate(4, 4, type: '4x4'),
    GridTemplate(6, 3, type: '6x3'),
    GridTemplate(7, 4, type: '7x4'),
    GridTemplate(8, 4, type: '8x4'),
  ];
}
