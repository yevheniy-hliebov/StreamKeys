import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/deck/presentation/widgets/deck_devider.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_header.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_items.dart';

class DeckPageList<T extends DeckPageListBloc> extends StatelessWidget {
  const DeckPageList({super.key});

  @override
  Widget build(BuildContext context) {
    final T provider = context.read<T>();

    return Container(
      color: AppColors.of(context).surface,
      child: Column(
        children: <Widget>[
          DeckPageListHeader(
            onPressedAdd: () {
              provider.add(DeckPageListAddPage());
            },
            onPressedDelete: () {
              provider.add(DeckPageListDeletePage());
            },
            onPressedEdit: () {
              provider.add(DeckPageListStartEditingPage());
            },
          ),
          const DeckDevider(axis: Axis.vertical),
          BlocBuilder<T, DeckPageListState>(
            builder: (BuildContext context, DeckPageListState state) {
              if (state is DeckPageListLoaded) {
                return DeckPageListItems(
                  currentPageName: state.currentPageName,
                  pages: state.pages,
                  isEditing: state.isEditing,
                  onSelectPage: (String pageName) {
                    provider.add(DeckPageListSelectPage(pageName));
                  },
                  onStopEditing: (String newPageName) {
                    provider.add(DeckPageListStopEditingPage(newPageName));
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    provider.add(DeckPageListReorder(oldIndex, newIndex));
                  },
                );
              }
              return const Padding(
                padding: EdgeInsets.all(Spacing.xs),
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }
}
