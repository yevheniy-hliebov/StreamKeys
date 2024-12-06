import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/windows/providers/touch_deck_provider.dart';

class LeftSideBar extends StatelessWidget {
  const LeftSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TouchDeckProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.maxFinite,
          color: SColors.of(context).surface,
          constraints: const BoxConstraints(
            maxWidth: 216,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: provider.addPage,
                  label: const Text(
                    'Add page',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                ),
              ),
              Divider(
                thickness: 4,
                height: 0,
                color: SColors.of(context).outlineVariant,
              ),
              Expanded(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    return Container(
                      key: Key(provider.orderPages[index]),
                      color: provider.isCurrentPage(index)
                          ? SColors.primary
                          : SColors.of(context).background,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        iconColor: SColors.of(context).onBackground,
                        onTap: () => provider.selectPage(index),
                        leading: ReorderableDragStartListener(
                          index: index,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.drag_handle),
                          ),
                        ),
                        textColor: SColors.of(context).onBackground,
                        title: Text(provider.orderPages[index]),
                        trailing: IconButton(
                          onPressed: () => provider.deletePage(index),
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                  itemCount: provider.orderPages.length,
                  onReorder: provider.reorderPage,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
