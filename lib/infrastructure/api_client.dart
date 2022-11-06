import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final apiClientProvider = Provider<APIClient>((ref) => APIClient());

typedef JSON = Map<String, dynamic>;

class APIClient {
  Future<JSON> fetch(Uri uri) async {
    final response = await http.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 400) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Server Error (${response.statusCode})');
    }
  }
}
