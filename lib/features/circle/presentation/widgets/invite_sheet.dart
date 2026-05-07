import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';

class InviteSheet extends StatefulWidget {
  const InviteSheet({super.key});

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Invite your first person',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Type a loved one’s name for now. Lumi will create a 24-hour share link and hold their orb until they confirm.',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Mom',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: PrimaryGlowButton(
                  label: 'Create invite',
                  onPressed: () {
                    context.read<CircleBloc>().add(
                      CircleEvent.inviteRequested(
                        name: _controller.text.trim(),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              context.read<CircleBloc>().add(
                CircleEvent.inviteLinkRequested(name: _controller.text.trim()),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Generate share link'),
          ),
        ],
      ),
    );
  }
}
