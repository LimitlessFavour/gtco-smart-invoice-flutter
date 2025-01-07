import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppNumberInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int? min;
  final int? max;

  const AppNumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: value.toString(),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: (val) {
                final newValue = int.tryParse(val) ?? value;
                if (min != null && newValue < min!) return;
                if (max != null && newValue > max!) return;
                onChanged(newValue);
              },
            ),
          ),
          Container(
            width: 24,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (max != null && value >= max!) return;
                    onChanged(value + 1);
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                InkWell(
                  onTap: () {
                    if (min != null && value <= min!) return;
                    onChanged(value - 1);
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
