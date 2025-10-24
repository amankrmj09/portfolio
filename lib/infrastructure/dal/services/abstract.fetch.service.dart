import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:portfolio/configs/constant_strings.dart';

abstract class FetchService<T> {
  final String fileName;
  final T Function(Map<String, dynamic>) fromJson;

  FetchService(this.fileName, this.fromJson);

  Future<List<T>> fetchData() async {
    http.Response? response;
    try {
      final String dataUrl = '$assetGithubUrl$fileName.json';
      response = await http.get(Uri.parse(dataUrl));
      // log('HTTP status: ${response.statusCode}');
      // log('HTTP body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => fromJson(json)).toList();
        } else {
          log('Fetched data is not a List for $fileName');
          return [];
        }
      } else {
        log('Error fetching data: HTTP ${response.statusCode}');
        return [];
      }
    } catch (e, stack) {
      log('Exception in fetchAll: $e', stackTrace: stack);
      return [];
    }
  }
}
