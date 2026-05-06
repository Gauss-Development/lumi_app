import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/shelf/presentation/bloc/shelf_bloc.dart';

class KeptShelfPage extends StatelessWidget {
  const KeptShelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      title: 'Kept Shelf',
      child: BlocBuilder<ShelfBloc, ShelfState>(
        builder: (context, state) {
          return state.when(
            initial: (items) => _ShelfList(items: items),
            loading: (items) => _ShelfList(items: items, isLoading: true),
            loaded: (items) => _ShelfList(items: items),
            failure: (items, message) =>
                _ShelfList(items: items, footerMessage: message),
          );
        },
      ),
    );
  }
}

class _ShelfList extends StatelessWidget {
  const _ShelfList({
    required this.items,
    this.isLoading = false,
    this.footerMessage,
  });

  final List<dynamic> items;
  final bool isLoading;
  final String? footerMessage;

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
