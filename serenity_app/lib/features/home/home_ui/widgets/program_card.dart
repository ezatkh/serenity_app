import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

import '../../../../core/services/local/LocalizationService.dart';

class ProgramCard extends StatelessWidget {
  final String programName;
  final String programType;
  final String statusText;
  final Color statusColor;

  const ProgramCard({
    super.key,
    required this.programName,
    required this.programType,
    required this.statusText,
    this.statusColor = AppColors.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);
    final double cardHeight = 125 * scale;
    final double padding = 16 * scale;
    final double statusFontSize = 11 * scale;
    final double smallTextSize = 13 * scale;
    final double titleSize = 16 * scale;
    final double labelSize = 14 * scale;
    return SizedBox(
      width: double.infinity,
      height: cardHeight, // Set a fixed height or calculate dynamically
      child: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.5),
                  AppColors.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
          ),

          Positioned(bottom: -20, left: -20, child: _buildCircle(50 * scale, 0.1)),
          Positioned(bottom: -10, right: -10, child: _buildCircle(60 * scale, 0.15)),

          Positioned(top: 20 * scale, left: 140 * scale, child: _buildCircle(10 * scale, 0.1)),
          Positioned(top: 30 * scale, left: 190 * scale, child: _buildCircle(10 * scale, 0.1)),
          Positioned(top: 80 * scale, left: 150 * scale, child: _buildCircle(10 * scale, 0.1)),
          Positioned(top: 100 * scale, left: 200 * scale, child: _buildCircle(8 * scale, 0.08)),

          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  programName,
                  style: TextStyle(color: Colors.white, fontSize: labelSize),
                ),
                SizedBox(height: 4 * scale),
                Text(
                  programType,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 15 * scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subscription status",
                      style: TextStyle(color: Colors.white70, fontSize: smallTextSize),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 18 * scale, vertical: 6 * scale),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.2, 1],
                          colors: [
                            AppColors.secondaryColor2,
                            AppColors.secondaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (statusText !=null && statusText.trim() != "") ?statusText : appLocalization.getLocalizedString("notAvailable"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: statusFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

// Reusable method to create circle
  Widget _buildCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }

}
