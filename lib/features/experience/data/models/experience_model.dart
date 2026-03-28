import 'package:equatable/equatable.dart';

class ExperienceModel extends Equatable {
  const ExperienceModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.companyLogo,
    required this.role,
    required this.period,
    required this.highlights,
  });

  final int id;
  final String companyId;
  final String companyName;
  final String companyLogo;
  final String role;
  final String period;
  final List<String> highlights;

  factory ExperienceModel.fromMap(String id, Map<String, dynamic> map) {
    return ExperienceModel(
      id: (map['id'] ?? 0),
      companyId: (map['company_id'] ?? ''),
      companyName: (map['company_name'] ?? ''),
      companyLogo: (map['company_logo'] ?? ''),
      role: (map['role'] ?? ''),
      period: (map['period'] ?? ''),
      highlights: List<String>.from(map['highlights'] ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company_id': companyId,
      'company_name': companyName,
      'company_logo': companyLogo,
      'role': role,
      'period': period,
      'highlights': highlights,
    };
  }

  @override
  List<Object?> get props => [
    id,
    companyId,
    companyName,
    companyLogo,
    role,
    period,
    highlights,
    companyId,
  ];
}
