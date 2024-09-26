import 'package:streamkeys/windows/models/action.dart';

class ButtonActionService {
  Future<void> pickImage(ButtonAction action) async {
    await action.pickImage();
  }

  Future<void> pickFile(ButtonAction action) async {
    await action.pickFile();
  }

  Future<void> clearAction(ButtonAction action) async {
    ButtonAction clearAction = ButtonAction(
      id: action.id,
      name: '',
      imagePath: '',
      filePath: '',
    );
    await clearAction.update();
  }

  Future<void> updateAction(ButtonAction action, String name, String imagePath,
      String filePath) async {
    ButtonAction updatedAction = ButtonAction(
      id: action.id,
      name: name,
      imagePath: imagePath,
      filePath: filePath,
    );
    await updatedAction.update();
  }
}
