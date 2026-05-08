import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

<<<<<<< HEAD
=======
import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/theme/app_colors.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';

class InviteSheet extends StatefulWidget {
  const InviteSheet({super.key});

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
<<<<<<< HEAD
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
=======
  String? _selectedRelationship;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepNight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Invite someone close',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Choose a relationship to create a quiet orb and a 24-hour share link. No typing needed.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AppConstants.relationshipSuggestions.map((String relationship) {
                  final bool selected = _selectedRelationship == relationship;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRelationship = relationship),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.softLavender.withValues(alpha: 0.14)
                            : Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected
                              ? AppColors.softLavender.withValues(alpha: 0.75)
                              : Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                      child: Text(
                        relationship,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: selected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(growable: false),
              ),
              const SizedBox(height: 24),
              PrimaryGlowButton(
                label: 'Create invite',
                glowColor: AppColors.softLavender,
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
              const SizedBox(height: 10),
              Center(
                child: TextButton(
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
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
                ),
              ),
            ],
          ),
<<<<<<< HEAD
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
=======
        ),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      ),
    );
  }
}
