import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';

class LumiComposerSheet extends StatefulWidget {
  const LumiComposerSheet({required this.member, super.key});

  final CircleMember member;

  @override
  State<LumiComposerSheet> createState() => _LumiComposerSheetState();
}

class _LumiComposerSheetState extends State<LumiComposerSheet> {
  LumiType _selectedType = LumiType.pure;
  double _intensity = 0.7;
  int _selectedColorValue = AppConstants.signatureColors.first.toARGB32();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final senderId = authState.maybeWhen(
      authenticated: (session) => session.userId,
      orElse: () => 'local-user',
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Send a Lumi to ${widget.member.displayName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: LumiType.values
                  .map((LumiType type) {
                    return ChoiceChip(
                      label: Text(type.label),
                      selected: _selectedType == type,
                      onSelected: (_) {
                        setState(() => _selectedType = type);
                      },
                    );
                  })
                  .toList(growable: false),
            ),
            if (_selectedType == LumiType.light) ...<Widget>[
              const SizedBox(height: 20),
              Text('Intensity', style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _intensity,
                onChanged: (double value) {
                  setState(() => _intensity = value);
                },
              ),
            ],
            if (_selectedType == LumiType.pulse ||
                _selectedType == LumiType.doodle)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Pulse and Doodle are scaffolded in the architecture and UI. This build sends the soft Pure/Light core loop first.',
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final Color swatch = AppConstants.signatureColors[index];
                  final bool isSelected =
                      swatch.toARGB32() == _selectedColorValue;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedColorValue = swatch.toARGB32());
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isSelected ? 48 : 40,
                      height: isSelected ? 48 : 40,
                      decoration: BoxDecoration(
                        color: swatch,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 12),
                itemCount: AppConstants.signatureColors.length,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryGlowButton(
              label: _selectedType == LumiType.light
                  ? 'Send Light Lumi'
                  : 'Send Pure Lumi',
              onPressed: () {
                if (_selectedType == LumiType.light) {
                  context.read<LumiBloc>().add(
                    LumiEvent.sendLightRequested(
                      senderId: senderId,
                      memberId: widget.member.id,
                      colorValue: _selectedColorValue,
                      intensity: _intensity,
                    ),
                  );
                } else {
                  context.read<LumiBloc>().add(
                    LumiEvent.sendPureRequested(
                      senderId: senderId,
                      memberId: widget.member.id,
                      colorValue: _selectedColorValue,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
