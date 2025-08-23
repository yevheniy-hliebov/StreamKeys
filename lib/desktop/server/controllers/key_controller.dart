import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/server/controllers/base_controller.dart';
import 'package:streamkeys/desktop/utils/local_json_file_manager.dart';

class KeyController extends BaseController {
  Future<Response> clickKey(
    Request request,
    String keyCode,
    DeckType dekcType,
  ) async {
    final jsonHelper = LocalJsonFileManager.storage(
      '${dekcType.name}_deck${kDebugMode ? '_dev' : ''}.json',
    );

    try {
      final json = await jsonHelper.read();

      if (json == null) {
        return Response.internalServerError(body: 'Failed to read deck json');
      }

      final currentPageId = json[DeckJsonKeys.currentPageId];
      final keyBindingDataJson = json[DeckJsonKeys.map][currentPageId][keyCode];

      if (keyBindingDataJson == null) {
        return Response.badRequest(body: 'Key binding data not found');
      }

      final keyBindingData = KeyBindingData.fromJson(keyBindingDataJson);
      for (final action in keyBindingData.actions) {
        await action.execute();
      }

      return Response.ok('Key actions executed successfully');
    } catch (e) {
      return handleError(e);
    }
  }
}
