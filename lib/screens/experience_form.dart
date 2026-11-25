import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _title = '';
  String _description = '';
  String _category = 'Full-Time';
  String _thumbnail = '';
  DateTime? _startedAt;
  DateTime? _endedAt;

  final List<String> _categories = [
    'Internship',
    'Research',
    'Volunteer',
    'Part-Time',
    'Full-Time',
    'Freelance',
  ];

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final selectedDate = isStartDate ? _startedAt : _endedAt;
    final fallbackDate = isStartDate
        ? DateTime.now()
        : (_startedAt ?? DateTime.now());
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? fallbackDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      if (isStartDate) {
        _startedAt = pickedDate;
        _startDateController.text = _formatDate(pickedDate);
      } else {
        _endedAt = pickedDate;
        _endDateController.text = _formatDate(pickedDate);
      }
    });
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  void _showSummary() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Experience berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Judul: $_title'),
                Text('Deskripsi: $_description'),
                Text('Kategori: $_category'),
                Text('Mulai: ${_formatDate(_startedAt!)}'),
                Text(
                  'Selesai: ${_endedAt == null ? 'Ongoing' : _formatDate(_endedAt!)}',
                ),
                Text(
                  'Thumbnail: ${_thumbnail.isEmpty ? 'Tidak ada' : _thumbnail}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Experience'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                maxLength: 255,
                decoration: _decoration(
                  'Title',
                  hint: 'e.g. Teaching Assistant',
                ),
                onChanged: (value) => _title = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 4,
                decoration: _decoration('Description'),
                onChanged: (value) => _description = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description cannot be empty.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _decoration('Category'),
                initialValue: _category,
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                onTap: () => _pickDate(isStartDate: true),
                decoration: _decoration('Start date')
                    .copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                validator: (_) =>
                    _startedAt == null ? 'Choose a start date.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endDateController,
                readOnly: true,
                onTap: () => _pickDate(isStartDate: false),
                decoration: _decoration('End date (optional)')
                    .copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                validator: (_) {
                  if (_endedAt != null &&
                      _startedAt != null &&
                      _endedAt!.isBefore(_startedAt!)) {
                    return 'End date must be on or after the start date.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: _decoration(
                  'Thumbnail URL (optional)',
                  hint: 'https://example.com/image.jpg',
                ),
                onChanged: (value) => _thumbnail = value.trim(),
                validator: (value) {
                  final url = value?.trim() ?? '';
                  if (url.isEmpty) return null;

                  final uri = Uri.tryParse(url);
                  if (uri == null ||
                      !{'http', 'https'}.contains(uri.scheme) ||
                      uri.host.isEmpty) {
                    return 'Enter a valid http or https URL.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showSummary();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
