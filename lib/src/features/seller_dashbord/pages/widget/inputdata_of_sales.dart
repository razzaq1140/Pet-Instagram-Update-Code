import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants/global_variables.dart';
import '../../../../common/widget/custom_text_field.dart';

class InputDataOfSales extends StatefulWidget {
  final String label;

  const InputDataOfSales({super.key, required this.label});

  @override
  State<InputDataOfSales> createState() => _InputDataOfSalesState();
}

class _InputDataOfSalesState extends State<InputDataOfSales> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: _controller,
                hint: 'Select Date',
                readOnly: true,
                onTap: () => selectDate(context),
                fillColor: colorScheme(context).surface,
                filled: true,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: colorScheme(context).surface,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  selectDate(context);
                },
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
