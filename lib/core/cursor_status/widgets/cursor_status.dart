import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/core/cursor_status/bloc/cursor_status_bloc.dart';

class CursorStatus extends StatelessWidget {
  final Widget? child;

  const CursorStatus({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CursorStatusBloc(),
      child: BlocBuilder<CursorStatusBloc, CursorStatusState>(
        builder: (context, state) {
          return MouseRegion(
            cursor: state.cursor,
            child: child,
          );
        },
      ),
    );
  }
}
