import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/placeholders/loader_placeholder.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/mobile/features/buttons/bloc/buttons_bloc.dart';
import 'package:streamkeys/mobile/features/buttons/presentation/widgets/grid_deck.dart';
import 'package:streamkeys/service_locator.dart';

class GridDeckScreen extends StatelessWidget {
  const GridDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = HttpButtonsApi(sl<ApiSecureStorage>());

    return BlocBuilder<ButtonsBloc, ButtonsState>(
      builder: (context, state) {
        if (state is ButtonsLoaded) {
          return Padding(
            padding: const EdgeInsets.all(Spacing.xs),
            child: GridDeck(
              grid: state.buttons.gridTemplate,
              buttons: state.buttons.pageMap,
              getImage: (keyCode) async {
                final response = await api.getImage(keyCode);
                return response.bytes;
              },
              onTap: api.clickButton,
            ),
          );
        } else if (state is ButtonsError) {
          return Center(
            child: Text(
              state.message,
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return const LoaderPlaceholder();
        }
      },
    );
  }
}
