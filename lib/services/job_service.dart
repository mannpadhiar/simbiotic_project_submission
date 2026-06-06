import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

class JobService {
  static const String _baseUrl = 'https://www.arbeitnow.com/api/job-board-api';

  Future<List<JobModel>> fetchJobs({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?page=$page'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> jobsJson = data['data'] ?? [];
        return jobsJson.map((json) => JobModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load jobs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch jobs: $e');
    }
  }
}
