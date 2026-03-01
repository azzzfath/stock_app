class ProfileModel {
  final String name;
  final String title;
  final String hobbies;
  final String about;
  final String github;
  final String linkedin;
  final String instagram;
  final String? base64Image;

  ProfileModel({
    required this.name,
    required this.title,
    required this.about,
    required this.hobbies,
    required this.github,
    required this.linkedin,
    required this.instagram,
    this.base64Image,
  });

  factory ProfileModel.defaultProfile() {
    return ProfileModel(
      name: 'Muhammad Azzam Fathurrahman',
      title: 'Computer Science Student',
      hobbies: 'Futsal, Gaming, Watching Film',
      about: 'ada lah',
      github: 'github.com/azzzfath',
      linkedin: 'linkedin.com/in/muhammad-azzam-946891286/',
      instagram: 'instagram.com/azzzfath/',
      base64Image: null,
    );
  }
}