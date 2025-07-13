import 'package:streamkeys/desktop/features/streamerbot/data/models/streamerbot_action.dart';

class GetActionsResponse {
  final String id;
  final String status;
  final int count;
  final List<StreamerBotAction> actions;

  GetActionsResponse({
    required this.id,
    required this.status,
    required this.count,
    required this.actions,
  });

  factory GetActionsResponse.fromJson(Map<String, dynamic> json) {
    return GetActionsResponse(
      id: json['id'],
      status: json['status'],
      count: json['count'],
      actions: (json['actions'] as List<dynamic>)
          .map((a) => StreamerBotAction.fromJson(a))
          .toList(),
    );
  }
}
