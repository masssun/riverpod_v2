abstract class GitHubAPI {
  static const String scheme = 'https';
  static const String host = 'api.github.com';

  final Uri uri;

  GitHubAPI(this.uri);
}

class GitHubSearchRepositoryAPI extends GitHubAPI {
  static const path = 'search/repositories';
  static const query = 'q';
  static const page = 'page';
  static const perPage = 'per_page';

  GitHubSearchRepositoryAPI({
    required String query,
    required int page,
    int perPage = 10,
  }) : super(Uri(
          scheme: GitHubAPI.scheme,
          host: GitHubAPI.host,
          path: GitHubSearchRepositoryAPI.path,
          queryParameters: {
            GitHubSearchRepositoryAPI.query: query,
            GitHubSearchRepositoryAPI.page: page.toString(),
            GitHubSearchRepositoryAPI.perPage: perPage.toString(),
          },
        ));
}
