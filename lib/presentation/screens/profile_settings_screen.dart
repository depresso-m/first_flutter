import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _syncControllers() {
    final account = ref.watch(currentUserProvider);
    if (account == null) return;

    void sync(TextEditingController controller, String value) {
      if (controller.text != value) {
        controller.text = value;
      }
    }

    sync(_firstNameController, account.firstName ?? '');
    sync(_lastNameController, account.lastName ?? '');
    sync(_emailController, account.email);
    sync(_phoneController, account.phone ?? '');
    sync(_cityController, account.city ?? '');
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await ref.read(authNotifierProvider.notifier).updateProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          city: _cityController.text.trim(),
        );

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль обновлён')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _syncControllers();

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки профиля')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _ProfileField(
                controller: _firstNameController,
                label: 'Имя',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              _ProfileField(
                controller: _lastNameController,
                label: 'Фамилия',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              _ProfileField(
                controller: _emailController,
                label: 'Почта',
                enabled: false,
              ),
              const SizedBox(height: 16),
              _ProfileField(
                controller: _phoneController,
                label: 'Номер телефона',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _ProfileField(
                controller: _cityController,
                label: 'Город',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    this.enabled = true,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
