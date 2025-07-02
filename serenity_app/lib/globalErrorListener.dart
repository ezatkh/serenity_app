import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/services/LocalizationService.dart';
import 'core/services/globalErrorService.dart';

class GlobalErrorListener extends StatelessWidget {
  final Widget child;
  const GlobalErrorListener({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    return ValueListenableBuilder<String?>(
      valueListenable: GlobalErrorNotifier.errorTextNotifier,
      builder: (context, errorText, _) {
        if (errorText != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(appLocalization.getLocalizedString('error'), style: const TextStyle(color: AppColors.errorColor)),
                content: Text(errorText),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(appLocalization.getLocalizedString('ok')),
                  ),
                ],
              ),
            );
            GlobalErrorNotifier.clearError(); // Clear after showing
          });
        }
        return child;
      },
    );
  }
}
