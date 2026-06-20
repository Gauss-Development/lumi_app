import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/models/permissions/permission_status.dart';
import 'package:flutter_contacts/models/permissions/permission_type.dart';
import 'package:share_plus/share_plus.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/utils/invite_link_utils.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/circle/domain/entities/invitation.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';

enum InviteSheetMode { send, receive }

class InviteSheet extends StatefulWidget {
  const InviteSheet({
    this.initialCode,
    this.initialMode = InviteSheetMode.send,
    super.key,
  });

  final String? initialCode;
  final InviteSheetMode initialMode;

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _selectedRelationship;
  late InviteSheetMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    if (widget.initialCode != null && widget.initialCode!.isNotEmpty) {
      _codeController.text = widget.initialCode!.trim().toUpperCase();
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onCreatePressed(BuildContext context) {
    final String label = _labelController.text.trim().isNotEmpty
        ? _labelController.text.trim()
        : (_selectedRelationship ?? '');
    if (label.isEmpty) return;
    context.read<CircleBloc>().add(
      CircleEvent.invitationRequested(
        label: label,
        relationshipLabel: _selectedRelationship,
      ),
    );
  }

  void _onAcceptPressed(BuildContext context) {
    final String code = _codeController.text.trim();
    if (code.isEmpty) return;
    context.read<CircleBloc>().add(CircleEvent.inviteCodeAccepted(code: code));
    // Close the sheet immediately so the home page's success/failure
    // SnackBar isn't hidden behind it.
    Navigator.of(context).pop();
  }

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
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.viewInsetsOf(context).bottom + 28,
          ),
          child: BlocConsumer<CircleBloc, CircleState>(
            listenWhen: (previous, current) {
              final Invitation? prev = previous.maybeMap(
                loaded: (loaded) => loaded.pendingInvitation,
                orElse: () => null,
              );
              final Invitation? next = current.maybeMap(
                loaded: (loaded) => loaded.pendingInvitation,
                orElse: () => null,
              );
              return prev?.code != next?.code;
            },
            listener: (BuildContext context, CircleState state) {},
            buildWhen: (CircleState previous, CircleState current) {
              String? pendingCode(CircleState state) => state.maybeMap(
                loaded: (loaded) => loaded.pendingInvitation?.code,
                orElse: () => null,
              );
              return pendingCode(previous) != pendingCode(current) ||
                  previous.runtimeType != current.runtimeType;
            },
            buildWhen: (CircleState previous, CircleState current) {
              String? pendingCode(CircleState state) => state.maybeMap(
                loaded: (loaded) => loaded.pendingInvitation?.code,
                orElse: () => null,
              );
              return pendingCode(previous) != pendingCode(current) ||
                  previous.runtimeType != current.runtimeType;
            },
            builder: (BuildContext context, CircleState state) {
              final Invitation? pending = state.maybeMap(
                loaded: (loaded) => loaded.pendingInvitation,
                orElse: () => null,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _ModeToggle(
                    mode: _mode,
                    onChanged: (InviteSheetMode next) {
                      setState(() => _mode = next);
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_mode == InviteSheetMode.send) ...<Widget>[
                    if (pending != null)
                      _ShareCodeView(
                        invitation: pending,
                        onDone: () {
                          context.read<CircleBloc>().add(
                            const CircleEvent.pendingInvitationDismissed(),
                          );
                          Navigator.of(context).pop();
                        },
                      )
                    else
                      _SendInviteForm(
                        labelController: _labelController,
                        selectedRelationship: _selectedRelationship,
                        onRelationshipChanged: (String? next) {
                          setState(() => _selectedRelationship = next);
                        },
                        onPickContact: () => _pickContact(context),
                        onSubmit: () => _onCreatePressed(context),
                      ),
                  ] else
                    _ReceiveCodeForm(
                      codeController: _codeController,
                      onSubmit: () => _onAcceptPressed(context),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickContact(BuildContext context) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact picking is available on mobile devices.'),
        ),
      );
      return;
    }

    final PermissionStatus status = await FlutterContacts.permissions.request(
      PermissionType.read,
    );
    if (status != PermissionStatus.granted &&
        status != PermissionStatus.limited) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contacts permission is needed to pick someone.'),
        ),
      );
      return;
    }

    final Contact? contact = await FlutterContacts.native.showPicker();
    if (contact == null || !context.mounted) {
      return;
    }

    final String name = contact.displayName?.trim() ?? '';
    if (name.isNotEmpty) {
      _labelController.text = name;
    }
    setState(() {});
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final InviteSheetMode mode;
  final ValueChanged<InviteSheetMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _ToggleSegment(
              label: 'Send invite',
              selected: mode == InviteSheetMode.send,
              onTap: () => onChanged(InviteSheetMode.send),
            ),
          ),
          Expanded(
            child: _ToggleSegment(
              label: 'Have a code?',
              selected: mode == InviteSheetMode.receive,
              onTap: () => onChanged(InviteSheetMode.receive),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.softLavender.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SendInviteForm extends StatelessWidget {
  const _SendInviteForm({
    required this.labelController,
    required this.selectedRelationship,
    required this.onRelationshipChanged,
    required this.onPickContact,
    required this.onSubmit,
  });

  final TextEditingController labelController;
  final String? selectedRelationship;
  final ValueChanged<String?> onRelationshipChanged;
  final VoidCallback onPickContact;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Invite someone close',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Pick a label and we will create a 7-day code you can share over text, email, or in person.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        _LumiInput(
          controller: labelController,
          hint: 'Their name',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onPickContact,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          icon: const Icon(Icons.contacts_outlined, size: 18),
          label: const Text('Choose from contacts'),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: AppConstants.relationshipSuggestions
              .map((String relationship) {
                final bool selected = selectedRelationship == relationship;
                return GestureDetector(
                  onTap: () =>
                      onRelationshipChanged(selected ? null : relationship),
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
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              })
              .toList(growable: false),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: labelController,
          builder: (BuildContext context, Widget? _) {
            final bool canSubmit =
                labelController.text.trim().isNotEmpty ||
                (selectedRelationship?.isNotEmpty ?? false);
            return PrimaryGlowButton(
              label: 'Create invite',
              glowColor: AppColors.softLavender,
              onPressed: canSubmit ? onSubmit : null,
            );
          },
        ),
      ],
    );
  }
}

class _ShareCodeView extends StatelessWidget {
  const _ShareCodeView({required this.invitation, required this.onDone});

  final Invitation invitation;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String inviteUrl = InviteLinkUtils.buildInviteUrl(invitation.code);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Share this code',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Send the link to ${invitation.inviteeLabel}. After install, Lumi opens ready to connect.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.softLavender.withValues(alpha: 0.4),
            ),
          ),
          child: Center(
            child: SelectableText(
              invitation.code,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontFamily: 'Courier',
                letterSpacing: 6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Expires ${_formatExpiry(invitation.expiresAt)}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
          ),
        ),
        const SizedBox(height: 16),
        SelectableText(
          inviteUrl,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () async {
            await Share.share(
              'Join my Lumi circle: $inviteUrl\nOr enter code ${invitation.code}',
              subject: 'Lumi invite',
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          icon: const Icon(Icons.ios_share_rounded, size: 18),
          label: const Text('Share invite link'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: inviteUrl));
            messenger.showSnackBar(
              const SnackBar(content: Text('Invite link copied')),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text('Copy link'),
        ),
        const SizedBox(height: 12),
        PrimaryGlowButton(
          label: 'Done',
          glowColor: AppColors.softLavender,
          onPressed: onDone,
        ),
      ],
    );
  }

  String _formatExpiry(DateTime expiresAt) {
    final Duration remaining = expiresAt.difference(DateTime.now());
    if (remaining.isNegative) return 'soon';
    if (remaining.inHours < 24) return 'in ${remaining.inHours}h';
    return 'in ${remaining.inDays}d';
  }
}

class _ReceiveCodeForm extends StatelessWidget {
  const _ReceiveCodeForm({
    required this.codeController,
    required this.onSubmit,
  });

  final TextEditingController codeController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Enter their code',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Paste the 10-character code someone shared with you. Both of your orbs will appear once accepted.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        _LumiInput(
          controller: codeController,
          hint: 'Code',
          textCapitalization: TextCapitalization.characters,
          maxLength: 10,
          textInputAction: TextInputAction.go,
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: codeController,
          builder: (BuildContext context, Widget? _) {
            final bool canSubmit = codeController.text.trim().length >= 6;
            return PrimaryGlowButton(
              label: 'Accept invite',
              glowColor: AppColors.softLavender,
              onPressed: canSubmit ? onSubmit : null,
            );
          },
        ),
      ],
    );
  }
}

class _LumiInput extends StatelessWidget {
  const _LumiInput({
    required this.controller,
    required this.hint,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.onSubmitted,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hint;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: TextField(
        controller: controller,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}
