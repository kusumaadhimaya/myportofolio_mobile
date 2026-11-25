import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _projectImageUrl = '';
  bool _isSubmitting = false;

  String? _validateUrl(String? value, {required bool optional}) {
    final url = value?.trim() ?? '';
    if (url.isEmpty && optional) return null;

    final uri = Uri.tryParse(url);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme.toLowerCase()) ||
        uri.host.isEmpty) {
      return 'Enter a valid URL starting with http:// or https://.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final authorized = await ensureLoggedIn(context);
      if (!authorized || !mounted) return;

      final project = Project(
        title: _title.trim(),
        description: _description.trim(),
        techStack: _techStack.trim(),
        projectUrl: _projectUrl.trim(),
        projectImageUrl: _projectImageUrl.trim(),
      );

      final authState = context.read<AuthState>();
      var token = authState.token;
      if (token == null) return;

      Project createdProject;
      try {
        createdProject = await context.read<ApiClient>().createProject(
          project,
          token: token,
        );
      } on ApiException catch (error) {
        if (error.statusCode != 401) rethrow;

        try {
          await authState.logout();
        } catch (_) {
          // AuthState clears the local token in its finally block.
        }
        if (!mounted) return;

        final loggedInAgain = await ensureLoggedIn(context);
        if (!loggedInAgain || !mounted) return;

        token = context.read<AuthState>().token;
        if (token == null) return;
        createdProject = await context.read<ApiClient>().createProject(
          project,
          token: token,
        );
      }

      if (!mounted) return;
      await _showSuccessDialog(createdProject);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Could not add project (status ${error.statusCode}).',
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _showSuccessDialog(Project project) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Project added successfully!'),
        content: Text('${project.title} was created (201 Created).'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const ProjectListScreen(),
                ),
              );
            },
            child: const Text('View Projects'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _title = value,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Title cannot be empty.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _description = value,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Description cannot be empty.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tech Stack',
                  hintText: 'Flutter, Django, Figma',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _techStack = value,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Tech stack cannot be empty.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Project URL',
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _projectUrl = value,
                validator: (value) => _validateUrl(value, optional: true),
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Project Image URL (Optional)',
                  hintText: 'https://example.com/image.png',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _projectImageUrl = value,
                validator: (value) => _validateUrl(value, optional: true),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
