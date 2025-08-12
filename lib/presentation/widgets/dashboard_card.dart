import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final Color
  baseColor; // Renamed 'color' to 'baseColor' for clarity with gradients
  final VoidCallback function;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.label,
    this.count,
    required this.baseColor,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10, // Higher elevation for a floating effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22), // Even more rounded corners
      ),
      shadowColor: baseColor.withOpacity(0.6), // Stronger, color-matched shadow
      clipBehavior:
          Clip.antiAlias, // Ensures gradient doesn't bleed outside corners
      child: InkWell(
        onTap: function,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          // Apply a Linear Gradient as background
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [baseColor, baseColor],
            ),
          ),
          padding: const EdgeInsets.all(20.0), // Increased internal padding
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space out icon and text/count
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align content to the left
            children: [
              // Icon at the top-left
              Icon(
                icon,
                size: 48, // Large icon size
                color: Colors.white.withValues(
                  alpha: 0.9,
                ), // White icon with slight transparency
              ),
              // Use a Spacer or SizedBox for flexible spacing
              const Spacer(),
              // Label
              Text(
                label,
                style: TextStyle(
                  fontFamily: "EXPOARABIC",
                  fontSize: 18,
                  fontWeight: FontWeight.w600, // Semi-bold for label
                  color: Colors.white.withOpacity(
                    0.9,
                  ), // White text for good contrast
                ),
              ),
              // Count (if available) or an arrow for navigation
              if (count != null) ...[
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontFamily: "EXPOARABIC",
                    fontSize: 38, // Very large and bold for impact
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons
                        .arrow_circle_right_outlined, // A subtle arrow indicating navigation
                    color: Colors.white54,
                    size: 28,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
