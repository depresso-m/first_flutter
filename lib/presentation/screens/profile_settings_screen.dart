import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/address_suggestion.dart';
import '../../core/models/app_theme_mode.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/address_autocomplete_field.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  String _getThemeName(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.light:
        return 'Светлая';
      case AppThemeMode.dark:
        return 'Тёмная';
      case AppThemeMode.system:
        return 'Системная';
    }
  }

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;

  // ignore: unused_field
  AddressSuggestion? _selectedCity;
  bool _isSaving = false;
  bool _isInitialized = false;

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
    // Only sync once on first build
    if (_isInitialized) return;
    
    final account = ref.read(currentUserProvider);
    if (account == null) return;

    _firstNameController.text = account.firstName ?? '';
    _lastNameController.text = account.lastName ?? '';
    _emailController.text = account.email;
    _phoneController.text = account.phone ?? '';
    _cityController.text = account.city ?? '';
    
    _isInitialized = true;
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
              AddressAutocompleteField(
                label: 'Город',
                hintText: 'Начните вводить название города...',
                type: AddressSuggestionType.city,
                controller: _cityController,
                initialValue: _cityController.text,
                onSelected: (suggestion) {
                  setState(() {
                    _selectedCity = suggestion;
                    _cityController.text = suggestion.data.city ?? 
                                          suggestion.data.cityWithType ?? 
                                          suggestion.value;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Тема приложения',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final currentTheme = ref.watch(themeNotifierProvider);
                  return Column(
                    children: AppThemeMode.values.map((theme) {
                      return RadioListTile<AppThemeMode>(
                        title: Text(_getThemeName(theme)),
                        value: theme,
                        groupValue: currentTheme,
                        onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(themeNotifierProvider.notifier)
                                .setTheme(value);
                          }
                        },
                      );
                    }).toList(),
                  );
                },
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
