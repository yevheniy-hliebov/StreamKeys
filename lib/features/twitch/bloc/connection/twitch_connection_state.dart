import 'package:equatable/equatable.dart';
import 'package:streamkeys/common/models/connection_status.dart';

class TwitchConnectionState extends Equatable {
  final ConnectionStatus broadcaster;
  final ConnectionStatus bot;

  const TwitchConnectionState({
    required this.broadcaster,
    required this.bot,
  });

  @override
  List<Object?> get props => [broadcaster, bot];
}
