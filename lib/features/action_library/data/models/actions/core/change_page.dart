import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/data/models/page_direction.dart';

export 'package:streamkeys/features/deck_pages/data/models/page_direction.dart';

extension PageDirectionExtension on PageDirection {
  String get capitalizedName => '${name[0].toUpperCase()}${name.substring(1)}';
}

class ChangePage extends BaseAction {
  late final PageDirection directions;

  static const String actionTypeName = 'change_page';

  ChangePage(PageDirection direction)
      : super(
            actionType: actionTypeName,
            dialogTitle: '') {
    directions = direction;
  }

  @override
  String get actionLabel => '${directions.capitalizedName} Page';

  @override
  String get actionName => actionLabel;

  @override
  FutureVoid execute({dynamic data}) async {
    if (data is KeyboardDeckPagesBloc) {
      final deckPagesBloc = data as KeyboardDeckPagesBloc?;
      deckPagesBloc?.add(DeckPagesChangeEvent(directions));
    } else {
      final deckPagesBloc = data as GridDeckPagesBloc?;
      deckPagesBloc?.add(DeckPagesChangeEvent(directions));
    }
  }

  @override
  Json toJson() {
    return {
      'action_type': actionType,
      'direction': directions.name,
    };
  }

  factory ChangePage.fromJson(Json json) {
    return ChangePage(
      json['direction'] == PageDirection.next.name
          ? PageDirection.next
          : PageDirection.previous,
    );
  }

  @override
  ChangePage copy() {
    return ChangePage(directions);
  }

  @override
  Widget? form(BuildContext context) {
    return null;
  }
}
