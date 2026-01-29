import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/job_model.dart';

class JobRemoteDataSource {
  final http.Client client;

  JobRemoteDataSource(this.client);

  Future<List<Job>> getJobs({Map<String, dynamic>? filters}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/jobs')
        .replace(queryParameters: filters);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jobs = data['data'] as List;
      return jobs.map((e) => Job.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }

  Future<Job> getJobById(String id) async {
    final response =
    await client.get(Uri.parse('${ApiConstants.baseUrl}/jobs/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('🌐 API Response: $data'); // DEBUG
      return Job.fromJson(data);
    } else {
      print('❌ HTTP Error: ${response.statusCode} - ${response.body}'); // DEBUG
      throw Exception('Failed to fetch job');
    }
  }



  Future<List<Job>> getJobsByIds(List<String> ids) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/jobs/bulk')
        .replace(queryParameters: {'ids': ids.join(',')});

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => Job.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch jobs by ids');
    }
  }

  Future<Job> createJob(Map<String, dynamic> payload) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/jobs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create job');
    }
  }

  Future<void> deleteJob(String id) async {
    final response =
    await client.delete(Uri.parse('${ApiConstants.baseUrl}/jobs/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete job');
    }
  }
}
