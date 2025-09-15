import 'dart:async';

import 'package:streamkeys/common/models/connection_status.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_process.dart';

abstract class IHidMacrosStatusMonitor {
  Stream<ConnectionStatus> get status;

  void startMonitoring();

  Future<void> checkStatus();

  void stopMonitoring();
}

class HidMacrosStatusMonitor implements IHidMacrosStatusMonitor {
  final IHidMacrosProcess process;

  HidMacrosStatusMonitor(this.process) {
    startMonitoring();
  }

  final _statusController = StreamController<ConnectionStatus>.broadcast();

  Timer? _timer;

  @override
  Stream<ConnectionStatus> get status => _statusController.stream;

  @override
  void startMonitoring() async {
    _timer?.cancel();

    await checkStatus();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await checkStatus();
    });
  }

  @override
  Future<void> checkStatus() async {
    final isRunning = await process.getStatus();
    if (isRunning) {
      _statusController.add(ConnectionStatus.connected);
    } else {
      _statusController.add(ConnectionStatus.notConnected);
    }
  }

  @override
  void stopMonitoring() {
    _timer?.cancel();
  }
}
