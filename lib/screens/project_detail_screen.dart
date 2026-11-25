import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final hasImage = project.projectImageUrl.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  project.projectImageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    width: double.infinity,
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Tech stack', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(project.techStack),
            const SizedBox(height: 16),
            Text('Description', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(project.description),
            const SizedBox(height: 16),
            Text('Project URL', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            SelectableText(
              project.projectUrl.isEmpty ? 'Not provided' : project.projectUrl,
            ),
          ],
        ),
      ),
    );
  }
}
