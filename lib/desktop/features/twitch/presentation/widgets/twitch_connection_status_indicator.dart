import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/common/widgets/connection_status_indicator.dart';
import 'package:streamkeys/desktop/features/twitch/bloc/twitch_bloc.dart';

class TwitchConnectionStatusIndicator extends StatelessWidget {
  const TwitchConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwitchBloc, TwitchState>(
      builder: (context, state) {
        ConnectionStatus status;
        if (state.broadcaster.connected && state.bot.connected) {
          status = ConnectionStatus.connected;
        } else if (state.broadcaster.connected || state.bot.connected) {
          status = ConnectionStatus.partiallyConnected;
        } else {
          status = ConnectionStatus.notConnected;
        }

        return GestureDetector(
          onSecondaryTapDown: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;

            final position = RelativeRect.fromRect(
              Rect.fromPoints(
                renderBox.localToGlobal(
                  details.localPosition,
                  ancestor: overlay,
                ),
                renderBox.localToGlobal(
                  details.localPosition,
                  ancestor: overlay,
                ),
              ),
              Offset.zero & overlay.size,
            );

            showMenu(
              context: context,
              position: position,
              items: [
                PopupMenuItem(
                  child: ConnectionStatusIndicator(
                    label: 'Broadcaster',
                    status: state.broadcaster.connected
                        ? ConnectionStatus.connected
                        : ConnectionStatus.notConnected,
                  ),
                ),
                PopupMenuItem(
                  child: ConnectionStatusIndicator(
                    label: 'Bot',
                    status: state.bot.connected
                        ? ConnectionStatus.connected
                        : ConnectionStatus.notConnected,
                  ),
                ),
              ],
            );
          },
          child: ConnectionStatusIndicator(label: 'Twitch', status: status),
        );
      },
    );
  }
}
