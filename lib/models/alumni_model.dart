/// Represents a single alumni profile in the portal.
class AlumniModel {
  final String id;
  final String name;
  final String domain;
  final String company;
  final String designation;
  final String batch;
  final String email;
  final String bio;
  final List<String> skills;

  const AlumniModel({
    required this.id,
    required this.name,
    required this.domain,
    required this.company,
    required this.designation,
    required this.batch,
    required this.email,
    required this.bio,
    this.skills = const [],
  });

  /// Returns initials from the first and last name for the avatar circle.
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
