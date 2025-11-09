import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/domain/entities/task.dart';
import 'package:todo_app/presentation/widgets/app_button.dart';
import 'package:todo_app/presentation/widgets/app_text_field.dart';

class EditTaskSheet extends StatefulWidget {
  final Task task;
  final void Function(Task updated) onSave;

  const EditTaskSheet({super.key, required this.task, required this.onSave});

  @override
  State<EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late Priority _priority;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _priority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter task title';
    final text = value.trim();
    if (text.length > 30) return 'Max 30 characters';

    return null;
  }

  String? _validateDesc(String? value) {
    final text = value?.trim() ?? '';
    if (text.length > 100) return 'Max 100 characters';
    return null;
  }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Task', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              AppTextField(controller: _titleController, label: 'Title', maxLength: 30, validator: _validateTitle),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              AppTextField(controller: _descController, label: 'Description', maxLength: 100, maxLines: 3, validator: _validateDesc),
              const SizedBox(height: 12),
              _buildPrioritySection(),
              const SizedBox(height: 16),
              AppButton.primary(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final updated = widget.task.copyWith(
                      title: _titleController.text.trim(),
                      description: _descController.text.trim(),
                      priority: _priority,
                    );
                    widget.onSave(updated);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<Priority> _buildPrioritySection() {
    return DropdownButtonFormField<Priority>(
            initialValue: _priority,
            decoration: const InputDecoration(labelText: 'Priority'),
            selectedItemBuilder: (context) {
              return Priority.values
                  .map(
                    (p) => Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: p.color,
                          radius: 8,
                        ),
                        const SizedBox(width: 4),
                        Text(p.label),
                      ],
                    ),
                  )
                  .toList();
            },
            items: Priority.values
                .map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: p.color,
                          radius: 8,
                        ),
                        const SizedBox(width: 4),
                        Text(p.label),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (p) => setState(() => _priority = p ?? _priority),
          );
  }
}