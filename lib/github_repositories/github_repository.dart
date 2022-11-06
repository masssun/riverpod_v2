class GitHubRepositoriesResponse {
  final List<GitHubRepository> items;

  const GitHubRepositoriesResponse({required this.items});

  factory GitHubRepositoriesResponse.fromJson(Map<String, dynamic> json) {
    return GitHubRepositoriesResponse(
        items: (json['items'] as List)
            .map((e) => GitHubRepository.fromJson(e))
            .toList());
  }
}

class GitHubRepository {
  final String fullName;
  final int stargazersCount;
  final String htmlUrl;
  final GitHubOwner gitHubOwner;

  const GitHubRepository({
    required this.fullName,
    required this.stargazersCount,
    required this.htmlUrl,
    required this.gitHubOwner,
  });

  String get stargazersCountText => '☆ $stargazersCount';

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      fullName: json['full_name'],
      stargazersCount: json['stargazers_count'],
      htmlUrl: json['html_url'],
      gitHubOwner: GitHubOwner.fromJson(json['owner']),
    );
  }
}

class GitHubOwner {
  final String avatarUrl;

  const GitHubOwner({required this.avatarUrl});

  factory GitHubOwner.fromJson(Map<String, dynamic> json) {
    return GitHubOwner(avatarUrl: json['avatar_url']);
  }
}
