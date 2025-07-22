import 'package:equatable/equatable.dart';

class StreamerBotAction extends Equatable {
  final String id;
  final String name;
  final String group;
  final bool enabled;
  final int subactionCount;

  const StreamerBotAction({
    required this.id,
    required this.name,
    required this.group,
    required this.enabled,
    required this.subactionCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'enabled': enabled,
      'subaction_count': subactionCount,
    };
  }

  factory StreamerBotAction.fromJson(Map<String, dynamic> json) {
    return StreamerBotAction(
      id: json['id'],
      name: json['name'],
      group: json['group'],
      enabled: json['enabled'],
      subactionCount: json['subaction_count'],
    );
  }

  @override
  List<Object?> get props => [id, name, group, enabled, subactionCount];
}
