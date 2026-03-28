import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.title,
    required this.summary,
    required this.location,
    required this.email,
    required this.phone,
    this.linkedinUrl,
    this.githubUrl,
    this.cvUrl,
  });

  final String name;
  final String title;
  final String summary;
  final String location;
  final String email;
  final String phone;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? cvUrl;

  @override
  List<Object?> get props => [
        name,
        title,
        summary,
        location,
        email,
        phone,
        linkedinUrl,
        githubUrl,
        cvUrl,
      ];
}

