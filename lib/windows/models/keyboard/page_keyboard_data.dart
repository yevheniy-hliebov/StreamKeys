import 'package:streamkeys/windows/models/keyboard/keyboard_action_button_info.dart';
import 'package:streamkeys/windows/models/typedefs.dart';

class PageKeyboardData {
  final String pageName;
  Map<String, KeyboardActionButtonInfo> keyboardActions;

  PageKeyboardData({
    required this.pageName,
    this.keyboardActions = const {},
  });

  Json toJson() {
    return {
      'pageName': pageName,
      'keys': keyboardActions.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  static PageKeyboardData fromJson(
    String pageName, {
    Json keyboardActionsJson = const {},
  }) {
    return PageKeyboardData(
      pageName: pageName,
      keyboardActions: keyboardActionsJson.map(
        (key, value) {
          return MapEntry(key, KeyboardActionButtonInfo.fromJson(value));
        },
      ).cast<String, KeyboardActionButtonInfo>(),
    );
  }
}

// class PageKeyboardActions {
//   List<KeyboardActionButtonInfo>? functionRow;
//   List<List<KeyboardActionButtonInfo>>? mainBlock;
//   List<List<KeyboardActionButtonInfo>>? navigationBlock;
//   List<List<KeyboardActionButtonInfo>>? numpad;

//   PageKeyboardActions({
//     this.functionRow,
//     this.mainBlock,
//     this.navigationBlock,
//     this.numpad,
//   });

//   Map<String, dynamic>? toJson() {
//     if (functionRow == null &&
//         mainBlock == null &&
//         navigationBlock == null &&
//         numpad == null) {
//       return null;
//     }

//     List<List<dynamic>>? convertBlockToJson(
//         List<List<KeyboardActionButtonInfo>>? block) {
//       return block?.map((row) {
//         return row.map((key) {
//           return key.toJson();
//         }).toList();
//       }).toList();
//     }

//     return {
//       'functionRow': functionRow?.map((key) {
//         return key.toJson();
//       }).toList(),
//       'mainBlock': convertBlockToJson(mainBlock),
//       'navigationBlock': convertBlockToJson(navigationBlock),
//       'numpad': convertBlockToJson(numpad),
//     };
//   }

//   factory PageKeyboardActions.fromJson(Map<String, dynamic> json) {
//     List<List<KeyboardActionButtonInfo>>? convertBlockFromJson(dynamic block) {
//       if (block == null) return null;
//       return (block as List).map((row) {
//         return (row as List).map((key) {
//           return KeyboardActionButtonInfo.fromJson(key as Map<String, dynamic>);
//         }).toList();
//       }).toList();
//     }

//     return PageKeyboardActions(
//       functionRow: (json['functionRow'] as List?)?.map((key) {
//         return KeyboardActionButtonInfo.fromJson(key as Map<String, dynamic>);
//       }).toList(),
//       mainBlock: convertBlockFromJson(json['mainBlock']),
//       navigationBlock: convertBlockFromJson(json['navigationBlock']),
//       numpad: convertBlockFromJson(json['numpad']),
//     );
//   }
// }
