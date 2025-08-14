import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/data/Models/appointments_model.dart';
import 'package:serenity_app/widgets/tappable_icon.dart';

import '../../../../core/services/local/LocalizationService.dart';

class AppointmentItemWidget extends StatelessWidget {
  final AppointmentModel appointmentItem;
  final double scale;
  final VoidCallback onTap;

  const AppointmentItemWidget({
    Key? key,
    required this.appointmentItem,
    required this.scale,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);

    final TextStyle labelStyle = TextStyle(
      color: AppColors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 12 * scale,
    );

    final TextStyle valueStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 13 * scale,
      color: AppColors.primaryBoldColor,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded left content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  appointmentItem.name!,
                  style:  TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * scale,
                    color: AppColors.black
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Status label and value
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLocalization.getLocalizedString('status'), style: labelStyle,),
                        const SizedBox(height: 3),
                        Text(appointmentItem.status!, style: valueStyle),
                      ],
                    ),
                    const SizedBox(width: 24),

                    // Owner label and value
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLocalization.getLocalizedString('dateStart'), style: labelStyle),
                        const SizedBox(height: 3),
                        Text(
                          appointmentItem.dateStart!,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13 * scale,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          TappableIcon(
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
