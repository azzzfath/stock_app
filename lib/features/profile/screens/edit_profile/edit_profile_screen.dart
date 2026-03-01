import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/profile_text_field.dart';
import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController titleCtrl;
  late TextEditingController hobbiesCtrl;
  late TextEditingController aboutCtrl;
  late TextEditingController githubCtrl;
  late TextEditingController linkedinCtrl;
  late TextEditingController instaCtrl;

  @override
  void initState() {
    super.initState();
    final currentProfile = ref.read(profileProvider);
    nameCtrl = TextEditingController(text: currentProfile.name);
    titleCtrl = TextEditingController(text: currentProfile.title);
    hobbiesCtrl = TextEditingController(text: currentProfile.hobbies);
    aboutCtrl = TextEditingController(text: currentProfile.about);
    githubCtrl = TextEditingController(text: currentProfile.github);
    linkedinCtrl = TextEditingController(text: currentProfile.linkedin);
    instaCtrl = TextEditingController(text: currentProfile.instagram);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    titleCtrl.dispose();
    hobbiesCtrl.dispose();
    aboutCtrl.dispose();
    githubCtrl.dispose();
    linkedinCtrl.dispose();
    instaCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {

    final newProfile = ProfileModel(
      name: nameCtrl.text,
      title: titleCtrl.text,
      hobbies: hobbiesCtrl.text,
      about : aboutCtrl.text,
      github: githubCtrl.text,
      linkedin: linkedinCtrl.text,
      instagram: instaCtrl.text,
    );

    ref.read(profileProvider.notifier).updateProfile(newProfile);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            ProfileTextField(controller: nameCtrl, label: 'Nama Lengkap', icon: Iconsax.user),
            const SizedBox(height: 16),

            ProfileTextField(controller: titleCtrl, label: 'Pekerjaan / Status', icon: Iconsax.briefcase),
            const SizedBox(height: 16),

            ProfileTextField(controller: hobbiesCtrl, label: 'Hobi (Pisahkan dengan koma)', icon: Iconsax.magic_star),
            const SizedBox(height: 16),

            ProfileTextField(controller: aboutCtrl, label: 'about', icon: Iconsax.profile_tick),
            const SizedBox(height: 32),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Media Sosial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 16),

            ProfileTextField(controller: githubCtrl, label: 'GitHub URL', icon: Iconsax.code),
            const SizedBox(height: 16),

            ProfileTextField(controller: linkedinCtrl, label: 'LinkedIn URL', icon: Iconsax.link),
            const SizedBox(height: 16),

            ProfileTextField(controller: instaCtrl, label: 'Instagram Username', icon: Iconsax.camera),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save changes', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

          ],
        ),
      ),
    );
  }
}