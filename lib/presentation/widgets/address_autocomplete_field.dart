import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/address_suggestion.dart';
import '../../core/utils/debouncer.dart';
import '../providers/address_provider.dart';

/// Type of address suggestion
enum AddressSuggestionType { city, street, fullAddress }

/// A reusable widget for address autocomplete using DaData API
class AddressAutocompleteField extends ConsumerStatefulWidget {
  final String label;
  final String? hintText;
  final AddressSuggestionType type;
  final String? restrictToCityFiasId;
  final ValueChanged<AddressSuggestion> onSelected;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const AddressAutocompleteField({
    super.key,
    required this.label,
    required this.type,
    required this.onSelected,
    this.hintText,
    this.restrictToCityFiasId,
    this.initialValue,
    this.validator,
    this.controller,
  });

  @override
  ConsumerState<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState
    extends ConsumerState<AddressAutocompleteField> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  List<AddressSuggestion> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = widget.initialValue!;
    }

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _debouncer.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Hide suggestions when focus is lost
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted && !_focusNode.hasFocus) {
          setState(() => _showSuggestions = false);
        }
      });
    }
  }

  void _onTextChanged(String value) {
    _debouncer.run(() async {
      if (!mounted) return;
      
      if (value.trim().length < 2) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
          _showSuggestions = false;
        });
        return;
      }

      setState(() => _isLoading = true);

      try {
        List<AddressSuggestion> results;

        switch (widget.type) {
          case AddressSuggestionType.city:
            results = await ref.read(suggestCitiesUseCaseProvider).execute(value);
            break;
          case AddressSuggestionType.street:
            results = await ref.read(suggestStreetsUseCaseProvider).execute(value);
            break;
          case AddressSuggestionType.fullAddress:
            if (widget.restrictToCityFiasId != null) {
              results = await ref
                  .read(suggestByCityUseCaseProvider)
                  .execute(value, widget.restrictToCityFiasId!);
            } else {
              results = await ref.read(suggestFullAddressUseCaseProvider).execute(value);
            }
            break;
        }

        if (mounted) {
          setState(() {
            _suggestions = results;
            _isLoading = false;
            _showSuggestions = results.isNotEmpty;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _suggestions = [];
            _isLoading = false;
            _showSuggestions = false;
          });
        }
      }
    });
  }

  void _selectSuggestion(AddressSuggestion suggestion) {
    String displayValue;
    switch (widget.type) {
      case AddressSuggestionType.city:
        displayValue = suggestion.data.cityWithType ??
            suggestion.data.city ??
            suggestion.value;
        break;
      case AddressSuggestionType.street:
        displayValue = suggestion.data.streetWithType ??
            suggestion.data.street ??
            suggestion.value;
        break;
      case AddressSuggestionType.fullAddress:
        displayValue = suggestion.value;
        break;
    }

    _controller.text = displayValue;
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
    });
    _focusNode.unfocus();
    widget.onSelected(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
            suffixIcon: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _suggestions = [];
                            _showSuggestions = false;
                          });
                        },
                      )
                    : null,
          ),
          onChanged: _onTextChanged,
          validator: widget.validator,
          textCapitalization: TextCapitalization.words,
        ),
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return _SuggestionTile(
                  suggestion: suggestion,
                  type: widget.type,
                  onTap: () => _selectSuggestion(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final AddressSuggestion suggestion;
  final AddressSuggestionType type;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.suggestion,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String? subtitle;

    switch (type) {
      case AddressSuggestionType.city:
        title = suggestion.data.cityWithType ??
            suggestion.data.city ??
            suggestion.value;
        subtitle = suggestion.data.regionWithType;
        break;
      case AddressSuggestionType.street:
        title = suggestion.data.streetWithType ??
            suggestion.data.street ??
            suggestion.value;
        subtitle = suggestion.data.cityWithType;
        break;
      case AddressSuggestionType.fullAddress:
        title = suggestion.value;
        subtitle = null;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
