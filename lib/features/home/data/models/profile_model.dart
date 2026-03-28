import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phoneNumber,
    required this.summary,
    required this.location,
    required this.linkedinUrl,
    required this.githubUrl,
    required this.resumeUrl,
    required this.imgUrl,
  });

  final String fullName;
  final String jobTitle;
  final String email;
  final String phoneNumber;
  final String summary;
  final String location;
  final String linkedinUrl;
  final String githubUrl;
  final String resumeUrl;
  final String imgUrl;

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      fullName: (map['full_name'] ?? 'Muhammad Abu Bakar'),
      jobTitle: (map['job_title'] ?? 'Mobile Application Developer'),
      email: (map['email'] ?? ''),
      phoneNumber: (map['phone_number'] ?? map['phone'] ?? ''),
      summary: (map['summary'] ?? ''),
      location: (map['location'] ?? ''),
      linkedinUrl: (map['linkedin_url'] ?? ''),
      githubUrl: (map['github_url'] ?? ''),
      resumeUrl: (map['resume_url'] ?? ''),
      imgUrl: (map['img_url'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'job_title': jobTitle,
      'email': email,
      'phone_number': phoneNumber,
      'summary': summary,
      'location': location,
      'linkedin_url': linkedinUrl,
      'github_url': githubUrl,
      'resume_url': resumeUrl,
      'img_url': imgUrl,
    };
  }

  @override
  List<Object?> get props => [
    fullName,
    jobTitle,
    email,
    phoneNumber,
    summary,
    location,
    linkedinUrl,
    githubUrl,
    resumeUrl,
    imgUrl,
  ];
}
