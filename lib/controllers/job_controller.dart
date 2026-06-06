import 'package:get/get.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';

class JobController extends GetxController {
  final JobService _jobService = JobService();

  final allJobs = <JobModel>[].obs;
  final filteredJobs = <JobModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final bookmarkedSlugs = <String>{}.obs;
  final currentPage = 1.obs;
  final hasMorePages = true.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final jobs = await _jobService.fetchJobs(page: 1);
      allJobs.assignAll(jobs);
      _filterJobs();
    } catch (_) {}
    finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreJobs() async {
    if (isLoadingMore.value || !hasMorePages.value) return;
    try {
      isLoadingMore.value = true;
      currentPage.value++;
      final jobs = await _jobService.fetchJobs(page: currentPage.value);
      if (jobs.isEmpty) {
        hasMorePages.value = false;
      } else {
        allJobs.addAll(jobs);
        _filterJobs();
      }
    } catch (_) {
      currentPage.value--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    _filterJobs();
  }

  void _filterJobs() {
    if (searchQuery.value.isEmpty) {
      filteredJobs.assignAll(allJobs);
    } else {
      final q = searchQuery.value.toLowerCase();
      filteredJobs.assignAll(allJobs.where((job) =>
          job.title.toLowerCase().contains(q) ||
          job.companyName.toLowerCase().contains(q)));
    }
  }

  void toggleBookmark(String slug) {
    if (bookmarkedSlugs.contains(slug)) {
      bookmarkedSlugs.remove(slug);
    } else {
      bookmarkedSlugs.add(slug);
    }
  }

  bool isBookmarked(String slug) => bookmarkedSlugs.contains(slug);
}
