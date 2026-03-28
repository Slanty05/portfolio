import 'package:equatable/equatable.dart';

class ExperienceItem extends Equatable {
  const ExperienceItem({
    required this.id,
    required this.company,
    required this.role,
    required this.period,
    required this.order,
    this.bullets = const [],
  });

  final String id;
  final String company;
  final String role;
  final String period;
  final int order;
  final List<String> bullets;

  @override
  List<Object?> get props => [id, company, role, period, order, bullets];
}

