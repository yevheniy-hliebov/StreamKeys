import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/placeholders/loader_placeholder.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/mobile/features/api_connection/bloc/api_connection_bloc.dart';
import 'package:streamkeys/mobile/features/api_connection/data/models/api_connection_data.dart';
import 'package:streamkeys/mobile/features/api_connection/presentation/widgets/api_connection_form.dart';

class ApiConnectionGate extends StatelessWidget {
  final Widget Function() builder;

  const ApiConnectionGate({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiConnectionBloc, ApiConnectionState>(
      builder: (context, state) {
        if (state is ApiConnectionLoaded) {
          final data = state.data;

          if (data == null || data.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('HTTP connection', style: AppTypography.subtitle),
                  ApiConnectionForm(
                    initialData: data ?? const ApiConnectionData(),
                    onUpdated: (data) {
                      context.read<ApiConnectionBloc>().add(
                        ApiConnectionSave(data),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return builder();
        }

        return const LoaderPlaceholder();
      },
    );
  }
}
