import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart';
import 'package:streamkeys/common/models/typedef.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_json_keys.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/desktop/server/controllers/base_controller.dart';
import 'package:streamkeys/desktop/utils/local_json_file_manager.dart';
import 'package:streamkeys/service_locator.dart';

class GridDeckController extends BaseController {
  final jsonHelper = LocalJsonFileManager.storage(
    '${DeckType.grid.name}_deck.json',
  );

  Future<Response> getButtons(Request request) async {
    try {
      final json = await jsonHelper.read();

      if (json == null) {
        return Response.internalServerError(
            body: 'Failed to read grid deck json');
      }

      final prefs = sl<SharedPreferences>();
      final index = prefs.getInt('selected_grid_template') ?? 0;

      final gridTemplate = GridTemplate.gridTemplates[index];
      final currentPageId = json[DeckJsonKeys.currentPageId];
      final pageMapJson = json[DeckJsonKeys.map][currentPageId] as Json?;

      final Json jsonResponse = {
        'grid_template': gridTemplate.toJson(),
        DeckJsonKeys.currentPageId: json[DeckJsonKeys.currentPageId],
        'page_map': pageMapJson?.map(
          (key, value) {
            final keyBindingDataJson = value as Json;

            return MapEntry(key, {
              DeckJsonKeys.keyName: keyBindingDataJson[DeckJsonKeys.keyName],
              DeckJsonKeys.keyBackgroundColor:
                  keyBindingDataJson[DeckJsonKeys.keyBackgroundColor],
              DeckJsonKeys.keyImagePath:
                  keyBindingDataJson[DeckJsonKeys.keyImagePath],
            });
          },
        ),
      };

      return Response.ok(
        jsonEncode(jsonResponse),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> getImage(
    Request request,
    String keyCode,
  ) async {
    try {
      final json = await jsonHelper.read();

      if (json == null) {
        return Response.internalServerError(
          body: 'Failed to read grid deck json',
        );
      }

      final currentPageId = json[DeckJsonKeys.currentPageId];
      final keyBindingDataJson = json[DeckJsonKeys.map][currentPageId][keyCode];

      if (keyBindingDataJson == null) {
        return Response.badRequest(body: 'Key binding data not found');
      }

      final imagePath = keyBindingDataJson[DeckJsonKeys.keyImagePath] as String;
      final imageFile = imagePath.isNotEmpty ? File(imagePath) : null;
      if (imageFile == null) {
        return Response.notFound('Image not found');
      }

      if (!imageFile.existsSync()) {
        return Response.notFound('Image not found');
      }

      return Response.ok(
        imageFile.readAsBytesSync(),
        headers: {'Content-Type': 'image/jpeg'},
      );
    } catch (e) {
      return handleError(e);
    }
  }
}
