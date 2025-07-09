import 'dart:io';

abstract class ProcessRunner {
  Future<ProcessResult> run(String executable, List<String> arguments);
  Future<Process> start(String executable, List<String> arguments,
      {ProcessStartMode mode});
}

class RealProcessRunner implements ProcessRunner {
  @override
  Future<ProcessResult> run(String executable, List<String> arguments) {
    return Process.run(executable, arguments);
  }

  @override
  Future<Process> start(String executable, List<String> arguments,
      {ProcessStartMode mode = ProcessStartMode.normal}) {
    return Process.start(executable, arguments, mode: mode);
  }
}
