import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SocialTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  Future<void> _launchUrl() async {
    String finalUrl = subtitle;

    // Add https://
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }

    final Uri url = Uri.parse(finalUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $finalUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),

      child: InkWell(
        onTap: _launchUrl,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(

            leading: Icon(icon, color: theme.colorScheme.primary),

            title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold)
            ),

            subtitle: Text(
              subtitle,
              style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  fontSize: 12
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            trailing: Icon(
              Iconsax.export_1,
              size: 18,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
            ),

          ),
        ),
      ),
    );
  }
}