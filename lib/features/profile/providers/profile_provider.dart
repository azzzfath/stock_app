import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import '../models/profile_model.dart';

class ProfileNotifier extends StateNotifier<ProfileModel> {
  final Box<String> _box = Hive.box<String>('user_profile');

  ProfileNotifier() : super(ProfileModel.defaultProfile()) {
    _loadProfile();
  }

  void _loadProfile() {
    final savedData = _box.get('my_profile');

    if (savedData != null) {
      try {
        final map = jsonDecode(savedData);

        state = ProfileModel(
          name: map['name'] ?? state.name,
          title: map['title'] ?? state.title,
          hobbies: map['hobbies'] ?? state.hobbies,
          about: map['about'] ?? state.about,
          github: map['github'] ?? state.github,
          linkedin: map['linkedin'] ?? state.linkedin,
          instagram: map['instagram'] ?? state.instagram,
          base64Image: map['base64Image'],
        );
      } catch (e) {
        print('$e');
      }
    }
  }

  void updateProfile(ProfileModel newProfile) {
    state = newProfile;

    final profileJson = jsonEncode({
      'name': newProfile.name,
      'title': newProfile.title,
      'hobbies': newProfile.hobbies,
      'about': newProfile.about,
      'github': newProfile.github,
      'linkedin': newProfile.linkedin,
      'instagram': newProfile.instagram,
      'base64Image': newProfile.base64Image,
    });

    _box.put('my_profile', profileJson);
  }

  void updateImage(String newBase64Image) {

    final updatedProfile = ProfileModel(
      name: state.name,
      title: state.title,
      hobbies: state.hobbies,
      about: state.about,
      github: state.github,
      linkedin: state.linkedin,
      instagram: state.instagram,
      base64Image: newBase64Image,
    );

    updateProfile(updatedProfile);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileModel>((ref) {
  return ProfileNotifier();
});