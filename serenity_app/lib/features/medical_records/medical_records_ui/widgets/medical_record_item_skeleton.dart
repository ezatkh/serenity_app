import 'package:flutter/material.dart';

class MedicalRecordItemSkeleton extends StatelessWidget {
  const MedicalRecordItemSkeleton({Key? key}) : super(key: key);

  Widget _buildSkeletonBox({double width = double.infinity, double height = 16, BorderRadius? borderRadius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                _buildSkeletonBox(width: screenWidth * 0.4, height: 20, borderRadius: BorderRadius.circular(8)),
                const SizedBox(height: 12),

                // Row 1 skeleton (Status & Owner)
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSkeletonBox(width: screenWidth * 0.2, height: 14),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSkeletonBox(width: screenWidth * 0.25, height: 14),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Row 2 skeleton (Type & Subtype)
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSkeletonBox(width: screenWidth * 0.2, height: 14),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSkeletonBox(width: screenWidth * 0.25, height: 14),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arrow icon placeholder
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(left: 8, top: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
