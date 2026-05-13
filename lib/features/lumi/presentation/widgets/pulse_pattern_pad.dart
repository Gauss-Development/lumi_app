import 'package:flutter/material.dart';

class PulsePatternPad extends StatelessWidget {
  const PulsePatternPad({
    required this.onTapBeat,
    required this.onReset,
    required this.recordedBeats,
    super.key,
  });

  final VoidCallback onTapBeat;
  final VoidCallback onReset;
  final List<int> recordedBeats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tap your rhythm',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Each tap records the timing between beats. Send at least two beats.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTapBeat,
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(24),
                gradient: RadialGradient(
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.18),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(Icons.multitrack_audio, size: 42),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recordedBeats.isEmpty
                ? const <Widget>[_BeatChip(label: 'No beats yet')]
                : recordedBeats
                      .map((int beat) => _BeatChip(label: '${beat}ms'))
                      .toList(growable: false),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onReset, child: const Text('Reset rhythm')),
        ],
      ),
    );
  }
}

class _BeatChip extends StatelessWidget {
  const _BeatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
