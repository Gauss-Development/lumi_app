import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';

class InviteSheet extends StatefulWidget {
  const InviteSheet({super.key});

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  String? _selectedRelationship;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Invite someone close',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose a relationship to create a quiet orb and a 24-hour share link. No typing needed.',
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppConstants.relationshipSuggestions
                .map(
                  (String relationship) => ChoiceChip(
                    label: Text(relationship),
                    selected: _selectedRelationship == relationship,
                    onSelected: (_) {
                      setState(() => _selectedRelationship = relationship);
                    },
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 20),
          PrimaryGlowButton(
            label: 'Create invite',
            onPressed: _selectedRelationship == null
                ? null
                : () {
                    context.read<CircleBloc>().add(
                      CircleEvent.inviteRequested(
                        name: _selectedRelationship!,
                        relationshipLabel: _selectedRelationship,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _selectedRelationship == null
                ? null
                : () {
                    context.read<CircleBloc>().add(
                      CircleEvent.inviteLinkRequested(
                        name: _selectedRelationship!,
                      ),
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
