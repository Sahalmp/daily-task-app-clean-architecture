import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../cubit/task_cubit/task_cubit.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';

@RoutePage()
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  Priority _priority = Priority.medium;

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

  void _onAdd() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<TaskCubit>().addNewTask(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _priority,
      );
      context.replaceRoute(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.replaceRoute(const HomeRoute()),
        ),
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Task title',
                maxLength: 30,
                validator: _validateTitle,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _descController,
                maxLines: 3,
                maxLength: 100,
                label: 'Task description',
                validator: _validateDesc,
              ),
              const SizedBox(height: 12),
              Row(children: [_buildPriorityDropdown()]),
              const Spacer(),
              AppButton.primary(
                onPressed: _onAdd,
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildPriorityDropdown() {
    return Expanded(
      child: DropdownButtonFormField<Priority>(
        initialValue: _priority,
        decoration: const InputDecoration(labelText: 'Priority'),
        selectedItemBuilder: (context) {
          return Priority.values
              .map(
                (p) => Row(
                  children: [
                    CircleAvatar(backgroundColor: p.color, radius: 8),
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
                    CircleAvatar(backgroundColor: p.color, radius: 8),
                    const SizedBox(width: 4),
                    Text(p.label),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (p) => setState(() => _priority = p ?? Priority.medium),
      ),
    );
  }
}
