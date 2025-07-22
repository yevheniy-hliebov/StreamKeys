import 'package:streamkeys/mobile/features/buttons/data/models/http_buttons_response.dart';
import 'package:streamkeys/mobile/features/buttons/data/services/http_buttons_api.dart';

class ButtonsRepository {
  final HttpButtonsApi _api;

  ButtonsRepository(this._api);

  Future<HttpButtonsResponse> fetchButtons() async {
    return await _api.getButtons();
  }
}
