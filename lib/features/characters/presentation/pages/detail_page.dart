import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/detail/detail_event.dart';
import '../bloc/detail/detail_state.dart';

class DetailPage extends StatelessWidget {
  final int? characterId;
  const DetailPage({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    final id = characterId;

    return BlocProvider(
      create: (_) {
        final bloc = sl<DetailBloc>();
        if (id != null) bloc.add(DetailStarted(id));
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
          actions: [
            BlocBuilder<DetailBloc, DetailState>(
              buildWhen: (p, c) => c is DetailLoaded || c is DetailLoading,
              builder: (context, state) {
                if (state is! DetailLoaded) return const SizedBox.shrink();

                return IconButton(
                  tooltip: state.isFavorite ? 'Unfavorite' : 'Favorite',
                  onPressed: () =>
                      context.read<DetailBloc>().add(const DetailFavoriteToggled()),
                  icon: Icon(
                    state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                );
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            if (id == null) {
              return const Center(child: Text('Invalid character id'));
            }

            return BlocBuilder<DetailBloc, DetailState>(
              builder: (context, state) {
                if (state is DetailLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DetailError) {
                  return Center(child: Text(state.message));
                }

                if (state is DetailEmpty) {
                  return const Center(child: Text('Character not found'));
                }

                if (state is DetailLoaded) {
                  final c = state.character;

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            c.image,
                            height: 220,
                            width: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 220,
                              width: 220,
                              alignment: Alignment.center,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        c.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),

                      _InfoTile(label: 'Species', value: c.species),
                      _InfoTile(label: 'Gender', value: c.gender),
                      _InfoTile(label: 'Origin', value: c.origin),
                      _InfoTile(label: 'Location', value: c.location),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        dense: true,
        title: Text(label),
        subtitle: Text(value.isEmpty ? '-' : value),
      ),
    );
  }
}
