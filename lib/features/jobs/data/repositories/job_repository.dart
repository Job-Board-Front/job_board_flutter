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

  Future<List<Job>> getSimilarJobs(String jobId, {int limit = 3}) async {
    try {
      print('🔎 Fetching similar jobs for: $jobId');

      // Récupérer le job actuel
      final currentJob = await getJobById(jobId);
      print('📋 Current job: ${currentJob.title}');
      print('🏢 Employment type: ${currentJob.employmentType}');

      // Créer les filtres pour les jobs similaires
      final filters = <String, dynamic>{
        'limit': (limit + 5).toString(), // Prendre plus pour filtrer ensuite
      };

      // Récupérer tous les jobs avec filtres
      final allJobs = await remote.getJobs(filters: filters);
      print('📦 Total jobs fetched: ${allJobs.length}');

      // Filtrer les jobs similaires
      final similarJobs = allJobs
          .where((job) => job.id != jobId && // Exclure le job actuel
          (job.employmentType == currentJob.employmentType || // Même type d'emploi
              job.techStack.any((tech) => currentJob.techStack.contains(tech)) || // Technologies similaires
              job.experienceLevel == currentJob.experienceLevel) // Même niveau
      )
          .take(limit)
          .toList();

      print('✅ Similar jobs found: ${similarJobs.length}');
      return similarJobs;
    } catch (e) {
      print('❌ Error fetching similar jobs: $e');
      return [];
    }
  }


}
