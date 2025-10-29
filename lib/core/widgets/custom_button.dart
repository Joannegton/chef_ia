import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final bool isOutlined;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 56,
    this.isOutlined = false,
    this.padding,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = isOutlined
        ? _buildOutlinedButton(context)
        : _buildElevatedButton(context);

    if (width != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: button,
      );
    }

    return SizedBox(
      height: height,
      child: button,
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: 0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? Colors.white,
                ),
              ),
            )
          : _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        side: BorderSide(
          color: backgroundColor ?? Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        elevation: 0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  backgroundColor ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}

class PrimaryButton extends CustomButton {
  const PrimaryButton({
    super.key,
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
    double height = 56,
    EdgeInsetsGeometry? padding,
    bool fullWidth = true,
  }) : super(
    label: label,
    onPressed: onPressed,
    isLoading: isLoading,
    icon: icon,
    width: width,
    height: height,
    padding: padding,
    fullWidth: fullWidth,
  );
}

class SecondaryButton extends CustomButton {
  const SecondaryButton({
    super.key,
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    IconData? icon,
    Color? backgroundColor,
    double? width,
    double height = 56,
    EdgeInsetsGeometry? padding,
    bool fullWidth = true,
  }) : super(
    label: label,
    onPressed: onPressed,
    isLoading: isLoading,
    icon: icon,
    backgroundColor: backgroundColor,
    width: width,
    height: height,
    isOutlined: true,
    padding: padding,
    fullWidth: fullWidth,
  );
}
