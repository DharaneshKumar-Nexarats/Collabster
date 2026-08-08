import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CareerSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilter;
  final bool showFilterButton;
  final EdgeInsetsGeometry padding;

  const CareerSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search jobs, internships, freelance...',
    this.onChanged,
    this.onClear,
    this.onFilterTap,
    this.hasActiveFilter = false,
    this.showFilterButton = true,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<CareerSearchBar> createState() => _CareerSearchBarState();
}

class _CareerSearchBarState extends State<CareerSearchBar> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;

    return Padding(
      padding: widget.padding,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          color: _isFocused ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused
                ? AppColors.primary
                : widget.hasActiveFilter
                    ? const Color(0xFF0284C7)
                    : const Color(0xFFE2E8F0),
            width: _isFocused || widget.hasActiveFilter ? 1.6 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isFocused
                  ? AppColors.primary.withOpacity(0.08)
                  : Colors.black.withOpacity(0.02),
              blurRadius: _isFocused ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                Icons.search_rounded,
                key: ValueKey(_isFocused),
                color: _isFocused ? AppColors.primary : const Color(0xFF94A3B8),
                size: 21,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            if (hasText)
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  if (widget.onChanged != null) {
                    widget.onChanged!('');
                  }
                  if (widget.onClear != null) {
                    widget.onClear!();
                  }
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF64748B),
                    size: 14,
                  ),
                ),
              ),
            if (widget.showFilterButton) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onFilterTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.hasActiveFilter
                            ? const Color(0xFFE0F2FE)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: widget.hasActiveFilter
                            ? const Color(0xFF0284C7)
                            : const Color(0xFF475569),
                        size: 17,
                      ),
                    ),
                    if (widget.hasActiveFilter)
                      Positioned(
                        top: 2,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ] else
              const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
