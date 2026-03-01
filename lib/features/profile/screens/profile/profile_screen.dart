import 'dart:convert'; // Tambahan untuk base64Decode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // Tambahan untuk pilih gambar
import 'package:iconsax/iconsax.dart';
import '../../providers/profile_provider.dart';
import '../edit_profile/edit_profile_screen.dart';
import 'widgets/profile_chip.dart';
import 'widgets/social_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // Image to Base64
  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);
      ref.read(profileProvider.notifier).updateImage(base64String);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profile = ref.watch(profileProvider);
    final hobbiesList = profile.hobbies
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: false,
            floating: true,
            snap: true,
            toolbarHeight: 80,
            titleSpacing: 24,

            title: const Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),

            actions: [
              GestureDetector(
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );

                },
                child: Container(
                  padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),

                  child: const Icon(
                    Iconsax.edit,
                    size: 20,
                    color: Colors.white,
                  ),

                ),
              ),

              const SizedBox(width: 24),

            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [

                      CircleAvatar(
                        radius: 60,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        backgroundImage: (profile.base64Image != null && profile.base64Image!.isNotEmpty)
                            ? MemoryImage(base64Decode(profile.base64Image!)) as ImageProvider
                            : NetworkImage('https://ui-avatars.com/api/?name=${Uri.encodeComponent(profile.name)}&size=256&background=random'),
                      ),

                      // Image edit
                      GestureDetector(
                        onTap: () => _pickImage(ref),
                        child: Container(
                          padding: const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 3, // Border tebal biar ikonnya misah dari foto
                            ),
                          ),

                          child: const Icon(Iconsax.camera, size: 20, color: Colors.white),

                        ),
                      ),


                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nama & Title
                  Text(
                    profile.name,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profile.title,
                    style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // Hobbies
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: hobbiesList.map((hobi) => ProfileChip(label: hobi)).toList(),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // About Me
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('About Me',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      profile.about,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Social Media
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Social Media',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  if (profile.github.isNotEmpty)
                    SocialTile(icon: Iconsax.code, title: 'GitHub', subtitle: profile.github),
                  if (profile.linkedin.isNotEmpty)
                    SocialTile(icon: Iconsax.briefcase, title: 'LinkedIn', subtitle: profile.linkedin),
                  if (profile.instagram.isNotEmpty)
                    SocialTile(icon: Iconsax.camera, title: 'Instagram', subtitle: profile.instagram),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}