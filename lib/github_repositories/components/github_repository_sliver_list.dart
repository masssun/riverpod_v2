import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../github_repository.dart';

typedef OnItemTap = Function(GitHubRepository repository);

class GitHubRepositorySliverList extends ConsumerWidget {
  final List<GitHubRepository> _items;
  final OnItemTap? _onItemTap;

  const GitHubRepositorySliverList({
    Key? key,
    required List<GitHubRepository> items,
    OnItemTap? onItemTap,
  })  : _items = items,
        _onItemTap = onItemTap,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final item = _items[index];
          return InkWell(
            onTap: () => _onItemTap?.call(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.network(item.gitHubOwner.avatarUrl),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.fullName),
                        const SizedBox(height: 8),
                        Text(item.stargazersCountText),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: _items.length,
      ),
    );
  }
}
