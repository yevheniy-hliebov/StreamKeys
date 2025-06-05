import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/actions/index.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_type_enum.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';
import 'package:streamkeys/features/server/controllers/base_controller.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';
import 'package:streamkeys/utils/json_read_and_save.dart';

class KeyboardDeckController extends BaseController {
  final ObsConnectionRepository obsConnectionRepository;
  final KeyboardDeckPagesBloc keyboardDeckPagesBloc;
  final TwitchRepository twitchRepository;

  final JsonHelper jsonHelper =
      JsonHelper.storage('${DeckType.keyboard.name}_deck.json');

  KeyboardDeckController({
    required this.obsConnectionRepository,
    required this.keyboardDeckPagesBloc,
    required this.twitchRepository,
  });

  Future<Response> clickKey(
    Request request,
    String stringKeyCode,
  ) async {
    try {
      int keyCode = int.tryParse(stringKeyCode) ?? -1;
      final message = 'clicked $keyCode';
      if (kDebugMode) {
        print(message);
      }

      Json? json = await jsonHelper.read();
      if (json != null) {
        final currentPage = json['current_page'];
        final keyDataJson = json['map'][currentPage][keyCode.toString()];
        if (keyDataJson != null) {
          final keyData = KeyboardKeyData.fromJson(keyDataJson);
          for (var action in keyData.actions) {
            if (action is ChangePage) {
              await action.execute(data: keyboardDeckPagesBloc);
            } else if (action.actionType.contains('twitch_')) {
              await action.execute(data: twitchRepository);
            } else {
              await action.execute(data: obsConnectionRepository.obs);
            }
          }
        }
      }

      return Response.ok(message);
    } catch (e) {
      return BaseController.handleError(e);
    }
  }
}
