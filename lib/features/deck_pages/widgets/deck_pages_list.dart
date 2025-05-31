import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/widgets/deck_page_list_tile.dart';

class DeckPagesList extends StatelessWidget {
  const DeckPagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckPagesBloc, DeckPagesState>(
      builder: (context, state) {
        if ((state is DeckPagesLoaded || state is DeckPagesEditingName) &&
            state.data != null) {
          final bloc = context.read<DeckPagesBloc>();
          final data = state.data!;

          return Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: data.orderPages.length,
              onReorder: (oldIndex, newIndex) {
                bloc.add(DeckPagesReorderEvent(oldIndex, newIndex));
              },
              itemBuilder: (context, index) {
                final pageName = data.orderPages[index];
                final isCurrent = data.currentPage == pageName;
                final currentColor = isCurrent
                    ? SColors.primary
                    : SColors.of(context).background;

                return Container(
                  key: Key(pageName),
                  color: currentColor,
                  padding: const EdgeInsets.only(right: 8),
                  child: DeckPageListTile(
                    pageName: pageName,
                    index: index,
                    isCurrent: isCurrent,
                    isEditing: state is DeckPagesEditingName,
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
