import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/services/haptics_service.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/adaptive_scroll.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/lumi/presentation/widgets/doodle_canvas.dart';
import 'package:lumi/features/lumi/presentation/widgets/pulse_pattern_pad.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/entitlement_features.dart';
import 'package:lumi/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:lumi/features/subscription/presentation/widgets/paywall_sheet.dart';

class LumiComposerSheet extends StatefulWidget {
  const LumiComposerSheet({required this.member, super.key});

  final CircleMember member;

  @override
  State<LumiComposerSheet> createState() => _LumiComposerSheetState();
}

class _LumiComposerSheetState extends State<LumiComposerSheet> {
  final HapticsService _hapticsService = const HapticsService();

  LumiType _selectedType = LumiType.pure;
  int _selectedColorValue = AppColors.peach.toARGB32();
  final List<int> _pulseBeats = <int>[];
  final List<DoodlePoint> _doodlePoints = <DoodlePoint>[];
  DateTime? _lastPulseTapAt;

  void _recordPulseBeat() {
    final DateTime now = DateTime.now();
    if (_lastPulseTapAt != null) {
      _pulseBeats.add(now.difference(_lastPulseTapAt!).inMilliseconds);
    }
    _lastPulseTapAt = now;
    setState(() {});
  }

  void _resetPulse() {
    _pulseBeats.clear();
    _lastPulseTapAt = null;
    setState(() {});
  }

  bool get _atPaceLimit =>
      widget.member.paceCount >= LumiLimits.maxLumisPerPairPerDay;

  bool _canSendForType(LumiType type) {
    return switch (type) {
      LumiType.pure => true,
      LumiType.light => true,
      LumiType.pulse => _pulseBeats.isNotEmpty,
      LumiType.doodle => _doodlePoints.length > 1,
    };
  }

  EntitlementStatus _entitlement(BuildContext context) {
    return context.watch<SubscriptionBloc>().state.maybeWhen(
      loaded: (EntitlementStatus status, _) => status,
      orElse: () => const EntitlementStatus.free(),
    );
  }

  void _selectType(BuildContext context, LumiType type) {
    final EntitlementStatus entitlement = _entitlement(context);
    if (!entitlement.canSendLumiType(type)) {
      PaywallSheet.show(context);
      return;
    }
    setState(() => _selectedType = type);
  }

  void _selectColor(BuildContext context, int colorValue) {
    final EntitlementStatus entitlement = _entitlement(context);
    if (!entitlement.composerColorValues().contains(colorValue)) {
      PaywallSheet.show(context);
      return;
    }
    setState(() => _selectedColorValue = colorValue);
  }

  String get _selectedDescription => switch (_selectedType) {
    LumiType.pure => 'A soft, steady light',
    LumiType.pulse => 'A gentle heartbeat',
    LumiType.doodle => 'Draw a small mark',
    LumiType.light => 'Just a feeling',
  };

  @override
  Widget build(BuildContext context) {
    final String senderId = context.watch<AuthBloc>().state.maybeWhen(
      authenticated: (session) => session.userId,
      orElse: () => 'local-user',
    );
    final Color selectedColor = Color(_selectedColorValue);
    final EntitlementStatus entitlement = _entitlement(context);
    final List<int> availableColors = entitlement.composerColorValues();
    final bool canSend =
        _canSendForType(_selectedType) &&
        entitlement.canSendLumiType(_selectedType) &&
        !_atPaceLimit;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepNight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: AdaptiveSheetBody(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Sending to',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.textFaint),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.member.displayName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 260,
                  child: Center(
                    child: _selectedType == LumiType.doodle
                        ? Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: selectedColor.withValues(alpha: 0.16),
                                  blurRadius: 60,
                                ),
                              ],
                            ),
                            child: DoodleCanvas(
                              points: _doodlePoints,
                              color: selectedColor,
                              onChanged: (List<DoodlePoint> points) {
                                setState(() {
                                  _doodlePoints
                                    ..clear()
                                    ..addAll(points);
                                });
                              },
                              onClear: () {
                                setState(_doodlePoints.clear);
                              },
                            ),
                          )
                        : GlowOrb(
                            color: selectedColor,
                            size: 240,
                            intensity: _selectedType == LumiType.pulse
                                ? 1.08
                                : 1,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'How it arrives',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textFaint,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: LumiType.values
                            .map((LumiType type) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: type == LumiType.values.last ? 0 : 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _selectType(context, type),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _selectedType == type
                                            ? selectedColor.withValues(
                                                alpha: 0.14,
                                              )
                                            : Colors.white.withValues(
                                                alpha: 0.03,
                                              ),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: _selectedType == type
                                              ? selectedColor.withValues(
                                                  alpha: 0.8,
                                                )
                                              : Colors.white.withValues(
                                                  alpha: 0.07,
                                                ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          switch (type) {
                                            LumiType.pure => 'Glow',
                                            LumiType.pulse => 'Pulse',
                                            LumiType.doodle => 'Doodle',
                                            LumiType.light => 'Color',
                                          },
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: _selectedType == type
                                                    ? Colors.white
                                                    : AppColors.textSecondary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          _selectedDescription,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textFaint),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedType == LumiType.pulse) ...<Widget>[
                  const SizedBox(height: 16),
                  PulsePatternPad(
                    onTapBeat: _recordPulseBeat,
                    onReset: _resetPulse,
                    recordedBeats: _pulseBeats,
                  ),
                ],
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Color',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textFaint,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: AppConstants.signatureColors
                      .map((Color color) {
                        final int colorValue = color.toARGB32();
                        final bool unlocked =
                            availableColors.contains(colorValue);
                        final bool selected = colorValue == _selectedColorValue;
                        return GestureDetector(
                          onTap: unlocked
                              ? () => _selectColor(context, colorValue)
                              : () => PaywallSheet.show(context),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: <Color>[
                                  Colors.white.withValues(
                                    alpha: unlocked ? 0.7 : 0.25,
                                  ),
                                  color.withValues(alpha: unlocked ? 1 : 0.35),
                                ],
                                stops: const <double>[0, 0.6],
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: color.withValues(
                                    alpha: selected ? 0.5 : 0.2,
                                  ),
                                  blurRadius: selected ? 22 : 14,
                                ),
                              ],
                              border: Border.all(
                                color: selected ? color : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
                if (_atPaceLimit) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    'You have reached today\'s gentle limit for ${widget.member.displayName}.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textFaint,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                PrimaryGlowButton(
                  label: 'Send Lumi',
                  glowColor: selectedColor,
                  onPressed: canSend
                      ? () {
                          switch (_selectedType) {
                            case LumiType.pure:
                              context.read<LumiBloc>().add(
                                LumiEvent.sendPureRequested(
                                  senderId: senderId,
                                  memberId: widget.member.id,
                                  colorValue: _selectedColorValue,
                                ),
                              );
                            case LumiType.light:
                              context.read<LumiBloc>().add(
                                LumiEvent.sendLightRequested(
                                  senderId: senderId,
                                  memberId: widget.member.id,
                                  colorValue: _selectedColorValue,
                                  intensity: 0.8,
                                ),
                              );
                            case LumiType.pulse:
                              context.read<LumiBloc>().add(
                                LumiEvent.sendPulseRequested(
                                  senderId: senderId,
                                  memberId: widget.member.id,
                                  colorValue: _selectedColorValue,
                                  pulsePattern: PulsePattern(
                                    List<int>.of(_pulseBeats),
                                  ),
                                ),
                              );
                            case LumiType.doodle:
                              context.read<LumiBloc>().add(
                                LumiEvent.sendDoodleRequested(
                                  senderId: senderId,
                                  memberId: widget.member.id,
                                  colorValue: _selectedColorValue,
                                  doodleStroke: DoodleStroke(
                                    List<DoodlePoint>.of(_doodlePoints),
                                  ),
                                ),
                              );
                          }
                          _hapticsService.playSoftSelection();
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
