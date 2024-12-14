import 'package:streamkeys/windows/models/typedefs.dart';

class GridTemplate {
  final String type;
  final int numberOfColumns;
  final int numberOfRows;

  GridTemplate(
    this.numberOfColumns,
    this.numberOfRows, {
    this.type = 'default',
  });

  int get totalCells => numberOfColumns * numberOfRows;

  Json toJson() {
    return {
      'type': type,
      'columns': numberOfColumns,
      'rows': numberOfRows,
    };
  }

  @override
  String toString() {
    return '${numberOfColumns}x$numberOfRows';
  }

  static GridTemplate fromJson(Json json) {
    return GridTemplate(
      json['columns'],
      json['rows'],
      type: json['type'],
    );
  }

  static List<GridTemplate> gridTemplates = [
    GridTemplate(3, 2),
    GridTemplate(4, 4),
    GridTemplate(6, 3),
    GridTemplate(7, 4),
    GridTemplate(8, 4),
  ];
}
