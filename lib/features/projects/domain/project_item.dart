import 'package:equatable/equatable.dart';

class ProjectItem extends Equatable {
  const ProjectItem({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    this.tags = const [],
    this.repoUrl,
    this.liveUrl,
  });

  final String id;
  final String title;
  final String description;
  final int order;
  final List<String> tags;
  final String? repoUrl;
  final String? liveUrl;

  @override
  List<Object?> get props => [id, title, description, order, tags, repoUrl, liveUrl];
}

