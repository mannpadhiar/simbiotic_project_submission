class JobModel {
  final String slug;
  final String title;
  final String companyName;
  final String location;
  final String description;
  final String url;
  final List<String> tags;
  final bool remote;

  JobModel({
    required this.slug,
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.url,
    required this.tags,
    required this.remote,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      companyName: json['company_name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : <String>[],
      remote: json['remote'] ?? false,
    );
  }
}
