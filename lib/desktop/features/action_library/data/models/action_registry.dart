import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/record_or_stream_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/screenshot_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/set_active_scene_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/source_mute_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/obs/source_visibility_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/streamerbot/do_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/launch_file_or_app_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_action.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/twitch/twitch_send_message_to_chat_acton.dart';

class ActionTypes {
  static const website = 'website';
  static const launcFileOrApp = 'launch_file_or_app';

  static const obsRecord = 'obs_record';
  static const obsStream = 'obs_stream';
  static const setActiveScene = 'set_active_scene';
  static const sourceMute = 'source_mute';
  static const sourceVisibility = 'source_visibility';
  static const obsScreenshot = 'obs_screenshot';

  static const streamerBotDoAction = 'streamerbot_do_action';

  static const twitchSendMessageToChat = 'twitch_send_message_to_chat';
}

void registerBindingActions() {
  BindingAction.register(ActionTypes.website, WebsiteAction.fromJson);
  BindingAction.register(
    ActionTypes.launcFileOrApp,
    LaunchFileOrAppAction.fromJson,
  );
  BindingAction.register(
    ActionTypes.setActiveScene,
    SetActiveSceneAction.fromJson,
  );
  BindingAction.register(ActionTypes.sourceMute, SourceMuteAction.fromJson);
  BindingAction.register(
    ActionTypes.sourceVisibility,
    SourceVisibilityAction.fromJson,
  );
  BindingAction.register(ActionTypes.obsScreenshot, ScreenshotAction.fromJson);
  BindingAction.register(ActionTypes.obsRecord, RecordOrStreamAction.fromJson);
  BindingAction.register(ActionTypes.obsStream, RecordOrStreamAction.fromJson);
  BindingAction.register(
    ActionTypes.streamerBotDoAction,
    StreamerBotDoAction.fromJson,
  );
  BindingAction.register(
    ActionTypes.twitchSendMessageToChat,
    TwitchSendMessageToChatAction.fromJson,
  );
}
