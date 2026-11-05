import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// Shown when Wi-Fi and mobile data are off.
/// It has no close button: it closes by itself when the internet is back.
class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // PopScope stops the Android back button from closing the dialog.
    return PopScope(
      canPop: false,
      child: AlertDialog(
        icon: const CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.wifi_off, color: AppColors.primary, size: 28),
        ),
        title: const Text(AppStrings.offlineTitle),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.offlineMessage, textAlign: TextAlign.center),
            SizedBox(height: 20),
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(height: 12),
            Text(
              AppStrings.waitingForConnection,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
