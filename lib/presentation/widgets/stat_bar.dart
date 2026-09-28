import 'package:flutter/material.dart';
import '../../core/utils/string_utils.dart';

class StatBar extends StatelessWidget {
  final String statName;
  final int statValue;
  final int maxStat;

  const StatBar({
    super.key,
    required this.statName,
    required this.statValue,
    this.maxStat = 255,
  });

  Color _getStatColor(int value) {
    if (value < 50) return Colors.redAccent;
    if (value < 80) return Colors.orangeAccent;
    if (value < 110) return Colors.amber;
    if (value < 140) return Colors.lightGreen;
    return Colors.tealAccent.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final translatedName = StringUtils.translateStatName(statName);
    final percentage = (statValue / maxStat).clamp(0.0, 1.0);
    final barColor = _getStatColor(statValue);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              translatedName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$statValue',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Container(
                    height: 10,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                  FractionallySizedBox(
                    widthFactor: percentage,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: barColor.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
