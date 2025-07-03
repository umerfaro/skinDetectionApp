import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  if (loadingText != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      loadingText!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
