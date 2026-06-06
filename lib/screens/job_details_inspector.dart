import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/job_controller.dart';
import '../models/job_model.dart';

class JobDetailInspector extends StatelessWidget {
  JobDetailInspector({super.key});

  final JobController controller = Get.find<JobController>();

  @override
  Widget build(BuildContext context) {
    final JobModel job = Get.arguments as JobModel;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: Text(job.companyName, style: const TextStyle(fontSize: 16, color: Colors.white)),
        centerTitle: true,
        actions: [
          Obx(() {
            final saved = controller.isBookmarked(job.slug);
            return IconButton(
              icon: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? const Color(0xFFE74C6F) : Colors.white,
              ),
              onPressed: () => controller.toggleBookmark(job.slug),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              '${job.companyName}  •  ${job.location.isNotEmpty ? job.location : "Remote"}',
              style: const TextStyle(color: Color(0xFF8B949E), fontSize: 13),
            ),
            const Divider(color: Color(0xFF30363D), height: 32),
            Html(
              data: job.description,
              style: {
                "body": Style(
                  color: const Color(0xFFC9D1D9),
                  fontSize: FontSize(14),
                  lineHeight: LineHeight(1.6),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "h1, h2, h3": Style(color: Colors.white, fontWeight: FontWeight.w600),
                "strong": Style(color: Colors.white),
                "a": Style(color: const Color(0xFF6C5CE7)),
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse(job.url);
              if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                Get.snackbar('Error', 'Could not open URL',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Apply Now', style: TextStyle(fontSize: 15)),
          ),
        ),
      ),
    );
  }
}
