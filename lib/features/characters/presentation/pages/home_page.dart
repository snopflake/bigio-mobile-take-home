import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeFetchRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Characters')),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(child: Text(state.message));
            }

            if (state is HomeEmpty) {
              return const Center(child: Text('No characters found'));
            }

            if (state is HomeLoaded) {
              return ListView.separated(
                itemCount: state.characters.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final c = state.characters[index];
                  return ListTile(
                    title: Text(c.name),
                    subtitle: Text('${c.species} • ${c.gender}'),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(c.image),
                    ),
                    onTap: () {
                      // detailpage
                      // context.pushNamed('detail', pathParameters: {'id': '${c.id}'});
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink(); 
          },
        ),
      ),
    );
  }
}
