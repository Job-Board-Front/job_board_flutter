import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_dto.dart';

class JobForm extends StatefulWidget {
  final Job? initialJob;
  final Function(CreateJobDto dto, String? logoPath, Uint8List? logoBytes) onSubmit;
  final bool isSubmitting;
  final String? errorMessage;
  final String submitLabel;
  final VoidCallback? onCancel;

  const JobForm({
    super.key,
    this.initialJob,
    required this.onSubmit,
    this.isSubmitting = false,
    this.errorMessage,
    this.submitLabel = 'Create Job',
    this.onCancel,
  });

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _techStackController = TextEditingController();
  final _submissionLinkController = TextEditingController();

  EmploymentType _employmentType = EmploymentType.fullTime;
  ExperienceLevel _experienceLevel = ExperienceLevel.mid;
  String? _salaryRange;
  String? _logoPath;
  XFile? _logoFile;
  Uint8List? _logoBytes; // For web support

  final List<Map<String, String>> _salaryRanges = [
    {'value': 'under-50k', 'label': 'Under \$50k'},
    {'value': '50k-100k', 'label': '\$50k - \$100k'},
    {'value': '100k-150k', 'label': '\$100k - \$150k'},
    {'value': 'over-150k', 'label': 'Over \$150k'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialJob != null) {
      final job = widget.initialJob!;
      _titleController.text = job.title;
      _descriptionController.text = job.description;
      _companyController.text = job.company;
      _locationController.text = job.location;
      _techStackController.text = job.techStack.join(', ');
      _submissionLinkController.text = job.submissionLink ?? '';
      _employmentType = job.employmentType;
      _experienceLevel = job.experienceLevel;
      _salaryRange = job.salaryRange;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _techStackController.dispose();
    _submissionLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        _logoFile = image;
        if (kIsWeb) {
          // On web, we need to read bytes instead of using file path
          final bytes = await image.readAsBytes();
          
          // Validate file size (2MB = 2 * 1024 * 1024 bytes)
          const maxSizeBytes = 2 * 1024 * 1024;
          if (bytes.length > maxSizeBytes) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image size must be less than 2MB. Please choose a smaller image.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
          
          setState(() {
            _logoBytes = bytes;
            _logoPath = image.name; // Store filename for web
          });
        } else {
          // Validate file size on mobile
          final file = File(image.path);
          final fileSize = await file.length();
          const maxSizeBytes = 2 * 1024 * 1024;
          
          if (fileSize > maxSizeBytes) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image size must be less than 2MB. Please choose a smaller image.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
          
          setState(() {
            _logoPath = image.path;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearLogo() {
    setState(() {
      _logoFile = null;
      _logoPath = null;
      _logoBytes = null;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final techStack = _techStackController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final dto = CreateJobDto(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        company: _companyController.text.trim(),
        location: _locationController.text.trim(),
        employmentType: _employmentType,
        experienceLevel: _experienceLevel,
        salaryRange: _salaryRange?.isNotEmpty == true ? _salaryRange : null,
        techStack: techStack,
        submissionLink: _submissionLinkController.text.trim(),
      );

      widget.onSubmit(dto, _logoPath, _logoBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.errorMessage!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            _buildTextField(
              controller: _titleController,
              label: 'Job Title',
              hint: 'e.g. Senior Flutter Developer',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                if (value.trim().length < 2) {
                  return 'Title must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildLogoField(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _companyController,
              label: 'Company',
              hint: 'e.g. Acme Inc.',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Company is required';
                }
                if (value.trim().length < 2) {
                  return 'Company must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe the role, responsibilities, and requirements...',
              maxLines: 6,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _locationController,
              label: 'Location',
              hint: 'e.g. Remote, New York, NY',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Location is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown<EmploymentType>(
                    label: 'Employment Type',
                    value: _employmentType,
                    items: EmploymentType.values.cast<EmploymentType?>(),
                    onChanged: (value) {
                      setState(() {
                        _employmentType = value!;
                      });
                    },
                    getLabel: (type) {
                      if (type == null) return '';
                      switch (type) {
                        case EmploymentType.fullTime:
                          return 'Full-time';
                        case EmploymentType.partTime:
                          return 'Part-time';
                        case EmploymentType.contract:
                          return 'Contract';
                        case EmploymentType.internship:
                          return 'Internship';
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown<ExperienceLevel>(
                    label: 'Experience Level',
                    value: _experienceLevel,
                    items: ExperienceLevel.values.cast<ExperienceLevel?>(),
                    onChanged: (value) {
                      setState(() {
                        _experienceLevel = value!;
                      });
                    },
                    getLabel: (level) {
                      if (level == null) return '';
                      switch (level) {
                        case ExperienceLevel.junior:
                          return 'Junior';
                        case ExperienceLevel.mid:
                          return 'Mid-level';
                        case ExperienceLevel.senior:
                          return 'Senior';
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdown<String?>(
              label: 'Salary Range (optional)',
              value: _salaryRange,
              items: [null, ..._salaryRanges.map((r) => r['value']!)],
              onChanged: (value) {
                setState(() {
                  _salaryRange = value;
                });
              },
              getLabel: (value) {
                if (value == null) return 'Not specified';
                return _salaryRanges.firstWhere((r) => r['value'] == value)['label']!;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _submissionLinkController,
              label: 'Application / Submission Link (optional)',
              hint: 'https://company.com/careers/apply',
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || (!uri.hasScheme || (!uri.scheme.startsWith('http')))) {
                    return 'Please enter a valid URL (e.g., https://example.com)';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _techStackController,
              label: 'Tech Stack',
              hint: 'e.g. Flutter, Dart, Firebase',
              helperText: 'Comma-separated list of technologies',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: widget.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.submitLabel),
                  ),
                ),
                if (widget.onCancel != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.isSubmitting ? null : widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? helperText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T?> items,
    required void Function(T?) onChanged,
    required String Function(T?) getLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T?>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T?>(
              value: item,
              child: Text(getLabel(item)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Logo (optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (_logoPath != null || widget.initialJob?.logoUrl != null)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _logoBytes != null
                      ? Image.memory(
                          _logoBytes!,
                          fit: BoxFit.cover,
                        )
                      : _logoPath != null && !kIsWeb
                          ? Image.file(
                              File(_logoPath!),
                              fit: BoxFit.cover,
                            )
                          : widget.initialJob?.logoUrl != null
                              ? Image.network(
                                  widget.initialJob!.logoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                                )
                              : const Icon(Icons.image),
                ),
              ),
            if (_logoPath != null || widget.initialJob?.logoUrl != null)
              const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text(_logoPath != null || widget.initialJob?.logoUrl != null
                    ? 'Change Logo'
                    : 'Select Logo'),
              ),
            ),
            if (_logoPath != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: _clearLogo,
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Image files only (jpg, jpeg, png, gif, webp), max 2MB',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
