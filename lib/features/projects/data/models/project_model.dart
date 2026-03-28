import 'package:equatable/equatable.dart';

class ProjectModel extends Equatable {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.category,
    required this.logo,
    required this.client,
    required this.relatedCompanyId,
    required this.description,
    required this.techIds,
    required this.stackUrl,
  });

  final int id;
  final String title;
  final String category;
  final String logo;
  final String client;
  final String relatedCompanyId;
  final List<String> description;
  final List<String> techIds;
  final StoreUrls stackUrl;

  factory ProjectModel.fromMap(String id, Map<String, dynamic> map) {
    return ProjectModel(
      id: (map['id'] ?? 0),
      title: (map['title'] ?? ''),
      category: (map['category'] ?? ''),
      logo: (map['logo'] ?? ''),
      client: (map['client'] ?? ''),
      relatedCompanyId: (map['related_company_id'] ?? ''),
      description: List<String>.from(map['description'] ?? const []),
      techIds: List<String>.from(map['tech_ids'] ?? const []),
      stackUrl: StoreUrls.fromMap(map['stack_url'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'logo': logo,
      'client': client,
      'related_company_id': relatedCompanyId,
      'description': description,
      'tech_ids': techIds,
      'apple_store_url': stackUrl.appleStoreUrl,
      'google_play_store_url': stackUrl.googlePlayStoreUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    logo,
    client,
    relatedCompanyId,
    description,
    techIds,
    stackUrl,
  ];
}

class StoreUrls extends Equatable {
  final String appleStoreUrl;
  final String googlePlayStoreUrl;

  const StoreUrls({
    required this.appleStoreUrl,
    required this.googlePlayStoreUrl,
  });

  factory StoreUrls.fromMap(Map<String, dynamic> map) {
    return StoreUrls(
      appleStoreUrl: map['apple_store_url'] ?? '',
      googlePlayStoreUrl: map['google_play_store_url'] ?? '',
    );
  }

  @override
  List<Object?> get props => [appleStoreUrl, googlePlayStoreUrl];
}
