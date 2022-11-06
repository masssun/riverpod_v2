import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_v2/github_repositories/components/search_text_field.dart';
import 'package:riverpod_v2/github_repositories/github_repositories_state.dart';

import 'components/github_repository_sliver_list.dart';

class GitHubRepositoriesScreen extends ConsumerStatefulWidget {
  const GitHubRepositoriesScreen({super.key});

  @override
  ConsumerState<GitHubRepositoriesScreen> createState() =>
      _GitHubRepositoriesScreenState();
}

final hogeProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return '';
});

class _GitHubRepositoriesScreenState
    extends ConsumerState<GitHubRepositoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gitHubRepositoriesProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('GitHub Repositories'),
        ),
        body: Column(children: [
          SearchTextField(
            onSearchPressed: (keyword) {
              ref.read(gitHubRepositoriesProvider.notifier).search(keyword);
            },
          ),
          Expanded(
            child: NotificationListener<ScrollEndNotification>(
              child: Scrollbar(
                child: RefreshIndicator(
                  child: CustomScrollView(
                    slivers: [
                      state.when(
                        data: (repositories) {
                          return GitHubRepositorySliverList(
                            items: repositories,
                            onItemTap: (item) {
                              ref
                                  .read(gitHubRepositoriesProvider.notifier)
                                  .showWebView(item.gitHubOwner.avatarUrl);
                            },
                          );
                        },
                        error: (error, _) {
                          if (state.hasValue) {
                            return GitHubRepositorySliverList(
                              items: state.value ?? [],
                              onItemTap: (item) {
                                ref
                                    .read(gitHubRepositoriesProvider.notifier)
                                    .showWebView(item.gitHubOwner.avatarUrl);
                              },
                            );
                          }
                          return SliverFillRemaining(
                              child: Center(child: Text(error.toString())));
                        },
                        loading: () {
                          return const SliverFillRemaining(
                              child:
                                  Center(child: CircularProgressIndicator()));
                        },
                      ),
                      SliverToBoxAdapter(
                        child: state.maybeWhen(
                          orElse: () {
                            if (state.isRefreshing) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 32),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            return const SizedBox();
                          },
                          error: (error, stackTrace) {
                            if (state.hasValue) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Center(child: Text(error.toString())),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                  onRefresh: () async {
                    ref.read(gitHubRepositoriesProvider.notifier).refresh();
                  },
                ),
              ),
              onNotification: (notification) {
                if (notification.metrics.extentAfter == 0) {
                  ref.read(gitHubRepositoriesProvider.notifier).searchNext();
                }
                return false;
              },
            ),
          ),
        ]));
  }
}
