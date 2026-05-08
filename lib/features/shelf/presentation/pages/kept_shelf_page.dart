import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

<<<<<<< HEAD
import 'package:lumi/core/widgets/lumi_scaffold.dart';
=======
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
import 'package:lumi/features/shelf/presentation/bloc/shelf_bloc.dart';

class KeptShelfPage extends StatelessWidget {
  const KeptShelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
<<<<<<< HEAD
      title: 'Kept Shelf',
      child: BlocBuilder<ShelfBloc, ShelfState>(
        builder: (context, state) {
          return state.when(
            initial: (items) => _ShelfList(items: items),
            loading: (items) => _ShelfList(items: items, isLoading: true),
            loaded: (items) => _ShelfList(items: items),
            failure: (items, message) =>
                _ShelfList(items: items, footerMessage: message),
=======
      padding: EdgeInsets.zero,
      child: BlocBuilder<ShelfBloc, ShelfState>(
        builder: (BuildContext context, ShelfState state) {
          return state.when(
            initial: (items) => _ShelfBody(items: items),
            loading: (items) => _ShelfBody(items: items, isLoading: true),
            loaded: (items) => _ShelfBody(items: items),
            failure: (items, message) =>
                _ShelfBody(items: items, footerMessage: message),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
          );
        },
      ),
    );
  }
}

<<<<<<< HEAD
class _ShelfList extends StatelessWidget {
  const _ShelfList({
=======
class _ShelfBody extends StatelessWidget {
  const _ShelfBody({
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    required this.items,
    this.isLoading = false,
    this.footerMessage,
  });

<<<<<<< HEAD
  final List<dynamic> items;
=======
  final List<KeptLumi> items;
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  final bool isLoading;
  final String? footerMessage;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    if (items.isEmpty && !isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Saved Lumis will rest here for the long arc.'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Text(
            footerMessage ?? (isLoading ? 'Loading…' : ''),
            style: Theme.of(context).textTheme.bodyMedium,
          );
        }

        final kept = items[index];
        return ListTile(
          tileColor: Colors.white.withValues(alpha: 0.04),
          title: Text(kept.senderName),
          subtitle: Text(kept.previewLabel),
          trailing: IconButton(
            onPressed: () {
              context.read<ShelfBloc>().add(
                ShelfEvent.removeRequested(kept.lumiId),
              );
            },
            icon: const Icon(Icons.delete_outline),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 12),
      itemCount: items.length + ((isLoading || footerMessage != null) ? 1 : 0),
=======
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _BackButton(onTap: () => Navigator.of(context).pop()),
                Text(
                  'Kept shelf',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textFaint,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Lights you've kept",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Lumis fade by morning. The ones that mattered, you can hold here.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (items.isEmpty && !isLoading)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Saved Lumis will rest here for the long arc.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            sliver: SliverList.separated(
              itemCount: items.length + ((isLoading || footerMessage != null) ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == items.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      footerMessage ?? (isLoading ? 'Loading…' : ''),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textFaint,
                      ),
                    ),
                  );
                }

                final KeptLumi kept = items[index];
                final Color color = AppColors.signaturePalette[index % AppColors.signaturePalette.length];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.035),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: <Color>[
                              Colors.white.withValues(alpha: 0.8),
                              color,
                              color.withValues(alpha: 0.35),
                              Colors.transparent,
                            ],
                            stops: const <double>[0, 0.2, 0.6, 1],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  kept.senderName,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  _when(kept.savedAt),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.textFaint),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              kept.previewLabel,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
            ),
          ),
      ],
    );
  }

  String _when(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inHours < 24) {
      return 'Tonight';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      icon: const Icon(Icons.arrow_back_rounded, size: 18),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    );
  }
}
