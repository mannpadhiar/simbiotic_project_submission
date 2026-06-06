import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job_controller.dart';
import '../models/job_model.dart';

class JobDashboard extends StatelessWidget {
  JobDashboard({super.key});

  final JobController controller = Get.find<JobController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildJobList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Text(
            'Hire.com',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Obx(() => IconButton(
                onPressed:
                    controller.isLoading.value ? null : controller.fetchJobs,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFF6C5CE7)),
                      )
                    : const Icon(Icons.refresh_rounded,
                        color: Color(0xFF8B949E), size: 22),
              )),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: TextField(
        controller: searchController,
        onChanged: controller.updateSearch,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: const Color(0xFF6C5CE7),
        decoration: InputDecoration(
          hintText: 'Search by title or company...',
          hintStyle: const TextStyle(color: Color(0xFF484F58), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6C5CE7), size: 20),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.close_rounded, color: Color(0xFF484F58), size: 18),
                onPressed: () {
                  searchController.clear();
                  controller.updateSearch('');
                },
              );
            }
            return const SizedBox.shrink();
          }),
          filled: true,
          fillColor: const Color(0xFF161B22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF30363D)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF30363D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildJobList() {
    return Obx(() {
      if (controller.isLoading.value && controller.allJobs.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
        );
      }

      if (controller.filteredJobs.isEmpty) {
        return Center(
          child: const Text(
            'No jobs found',
            style: TextStyle(color: Color(0xFF8B949E), fontSize: 15),
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              !controller.isLoadingMore.value &&
              controller.searchQuery.value.isEmpty) {
            controller.loadMoreJobs();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: controller.fetchJobs,
          color: const Color(0xFF6C5CE7),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.filteredJobs.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.filteredJobs.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF6C5CE7), strokeWidth: 2),
                  ),
                );
              }
              return _buildJobCard(controller.filteredJobs[index]);
            },
          ),
        ),
      );
    });
  }

  Widget _buildJobCard(JobModel job) {
    return Card(
      color: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF30363D)),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed('/detail', arguments: job),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Company initial
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color.fromARGB(255, 20, 163, 211),
                child: Text(
                  job.companyName.isNotEmpty ? job.companyName[0].toUpperCase() : '?',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              // Job info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFFC9D1D9), fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      job.location.isNotEmpty ? job.location : 'Remote',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Bookmark
              Obx(() {
                final saved = controller.isBookmarked(job.slug);
                return IconButton(
                  onPressed: () => controller.toggleBookmark(job.slug),
                  icon: Icon(
                    saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: saved ? const Color(0xFFE74C6F) : const Color(0xFF484F58),
                    size: 22,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
