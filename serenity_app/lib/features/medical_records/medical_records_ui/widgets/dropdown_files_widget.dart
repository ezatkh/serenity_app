import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import '../../../../data/Models/file_model.dart';

class CustomDropdownTextField extends StatefulWidget {
  final String label;
  final double scale;
  final Color? labelColor;
  final List<MedicalFolderModel> items;
  final MedicalFolderModel? selectedItem;
  final Function(MedicalFolderModel?) onChanged;
  final String? hint;

  const CustomDropdownTextField({
    super.key,
    required this.label,
    required this.scale,
    this.labelColor,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.hint,
  });

  @override
  State<CustomDropdownTextField> createState() =>
      _CustomDropdownTextFieldState();
}

class _CustomDropdownTextFieldState extends State<CustomDropdownTextField>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
    _animationController.forward();
  }

  void _closeDropdown() async {
    await _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              left: offset.dx,
              top: offset.dy + size.height + 10,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 10),
                child: Material(
                  color: Colors.transparent,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.backgroundColor,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 250),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: widget.items.length,
                            itemBuilder: (context, index) {
                              final item = widget.items[index];
                              return ListTile(
                                title: Text(
                                  item.name ?? "",
                                  style: TextStyle(
                                    fontSize: 12.0 * widget.scale,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                                onTap: () {
                                  widget.onChanged(item);
                                  _closeDropdown();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelFontSize = (11.0 * widget.scale).clamp(11.0, 13.0);
    final inputFontSize = (12.0 * widget.scale).clamp(12.0, 14.0);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: labelFontSize,
              color: widget.labelColor ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.0 * widget.scale),
          Material(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _toggleDropdown,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.selectedItem?.name ?? widget.hint ?? "",
                        style: TextStyle(
                          fontSize: inputFontSize,
                          color: widget.selectedItem != null
                              ? AppColors.black
                              : AppColors.grey,
                        ),
                      ),
                    ),
                      Icon(
                      _isDropdownOpen
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                        size: 24 * widget.scale,
                        color: AppColors.primaryBoldColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
