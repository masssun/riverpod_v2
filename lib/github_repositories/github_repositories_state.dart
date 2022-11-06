import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_v2/github_repositories/github_repository.dart';
import 'package:riverpod_v2/infrastructure/api_client.dart';
import 'package:riverpod_v2/infrastructure/github_api.dart';

final gitHubRepositoriesProvider = StateNotifierProvider<GitHubRepositories,
    AsyncValue<List<GitHubRepository>>>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return GitHubRepositories(apiClient: apiClient);
});

class GitHubRepositories
    extends StateNotifier<AsyncValue<List<GitHubRepository>>> {
  final APIClient _apiClient;
  String _query = '';
  int _page = 1;

  GitHubRepositories({required APIClient apiClient})
      : _apiClient = apiClient,
        super(const AsyncValue.loading());

  search(String query) async {
    _page = 1;
    _search(query);
  }

  searchNext() {
    if (state ==
        const AsyncLoading<List<GitHubRepository>>().copyWithPrevious(state)) {
      return;
    }
    state =
        const AsyncLoading<List<GitHubRepository>>().copyWithPrevious(state);
    _page++;
    _search(_query, isLoadMore: true);
  }

  refresh() {
    state =
        const AsyncLoading<List<GitHubRepository>>().copyWithPrevious(state);
    _page = 1;
    _search(_query);
  }

  showWebView(String url) {
    debugPrint('URL: $url');
  }

  _search(String query, {bool isLoadMore = false}) async {
    _query = query;
    final uri = GitHubSearchRepositoryAPI(query: query, page: _page).uri;
    try {
      final json = await _apiClient.fetch(uri);
      final response = GitHubRepositoriesResponse.fromJson(json);
      state = AsyncData([
        if (isLoadMore) ...state.value ?? [],
        ...response.items,
      ]);
    } catch (error, stackTrace) {
      state = AsyncError<List<GitHubRepository>>(error, stackTrace)
          .copyWithPrevious(state);
    }
  }
}
