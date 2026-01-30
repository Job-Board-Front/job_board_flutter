import '../models/job_model.dart';
import '../datasources/job_remote_datasource.dart';

class JobRepository {
  final JobRemoteDataSource remote;

  JobRepository(this.remote);

  Future<List<Job>> getJobs({Map<String, dynamic>? filters}) {
    return remote.getJobs(filters: filters);
  }

  Future<Job> getJobById(String id) {
    return remote.getJobById(id);
  }

  Future<List<Job>> getJobsByIds(List<String> ids) {
    return remote.getJobsByIds(ids);
  }

  Future<Job> createJob(Map<String, dynamic> payload) {
    return remote.createJob(payload);
  }

  Future<void> deleteJob(String id) {
    return remote.deleteJob(id);
  }

  Future<PaginatedResponse<Job>> getJobsPaginated({
    JobSearchFilters? filters,
  }) {
    return remote.getJobsPaginated(filters: filters);
  }
}
