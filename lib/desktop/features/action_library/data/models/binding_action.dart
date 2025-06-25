import 'package:flutter/widgets.dart';
import 'package:streamkeys/common/models/typedef.dart';

typedef FromJsonFunc = BindingAction Function(Json);

abstract class BindingAction {
  final String type;
  final String name;

  BindingAction({required this.type, required this.name});

  String get actionLabel => name;
  String get dialogTitle => '';

  BindingAction copyWith();

  Future<void> execute({Object? data});

  Widget? form(BuildContext context);

  void save() {}

  void cancel() {}

  void clear() {}

  Json toJson();

  static final Map<String, FromJsonFunc> _registry = {};

  static void register(String type, FromJsonFunc fromJson) {
    _registry[type] = fromJson;
  }

  factory BindingAction.fromJson(Json json) {
    final type = json['type'];
    final parser = _registry[type];
    if (parser != null) {
      return parser(json);
    }
    throw Exception('Unknown action type: $type');
  }

  void dispose();
}
