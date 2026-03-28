import 'package:equatable/equatable.dart';

class SkillModel extends Equatable {
  const SkillModel({required this.category, required this.skills});

  final String category;
  final List<String> skills;

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      category: (map['category'] ?? ''),
      skills: List<String>.from(map['skills'] ?? const []),
    );
  }

  @override
  List<Object?> get props => [category, skills];
}
