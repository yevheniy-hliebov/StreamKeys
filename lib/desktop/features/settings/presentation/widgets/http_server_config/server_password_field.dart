import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/copy_icon_button.dart';
import 'package:streamkeys/common/widgets/small_icon_button.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/settings/data/services/http_server_password_service.dart';

class ServerPasswordField extends StatefulWidget {
  const ServerPasswordField({super.key});

  @override
  State<ServerPasswordField> createState() => _ServerPasswordFieldState();
}

class _ServerPasswordFieldState extends State<ServerPasswordField> {
  final _controller = TextEditingController();
  bool _isObscure = true;
  final _passwordService = HttpServerPasswordService();

  @override
  void initState() {
    super.initState();
    _loadOrGeneratePassword();
  }

  Future<void> _loadOrGeneratePassword() async {
    final password = await _passwordService.loadOrCreatePassword();
    _controller.text = password;
    setState(() {});
  }

  Future<void> _regeneratePassword() async {
    final password = await _passwordService.generateAndSavePassword();
    _controller.text = password;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 220),
          child: TextField(
            readOnly: true,
            controller: _controller,
            obscureText: _isObscure,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: Spacing.xs,
                horizontal: Spacing.md,
              ),
              prefixIcon: SmallIconButton(
                icon: _isObscure ? Icons.visibility_off : Icons.visibility,
                onPressed: () => setState(() => _isObscure = !_isObscure),
              ),
              suffixIcon: SmallIconButton(
                tooltip: 'Regenerate password',
                icon: Icons.replay_outlined,
                onPressed: _regeneratePassword,
              ),
            ),
          ),
        ),
        const SizedBox(width: Spacing.xs),
        CopyIconButton(textToCopy: _controller.text),
      ],
    );
  }
}
