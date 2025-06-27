import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedef.dart';

typedef FromJsonFunc = BindingAction Function(Json);

abstract class BindingAction extends Equatable {
  final String id;
  final String type;
  final String name;

  const BindingAction({
    required this.id,
    required this.type,
    required this.name,
  });

  String get actionLabel => name;
  String get dialogTitle => '';
  Widget getIcon(BuildContext context);

  BindingAction copy();

  Future<void> execute({Object? data});

  Widget? form(
    BuildContext context, {
    void Function(BindingAction updatedAction)? onUpdate,
  });

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

  @override
  List<Object?> get props => [id, type, name];
}
