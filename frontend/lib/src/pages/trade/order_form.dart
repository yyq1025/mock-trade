import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/open_orders_provider.dart';

class OrderForm extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialValues;
  final Function? onfinished;
  const OrderForm({super.key, required this.initialValues, this.onfinished});

  @override
  ConsumerState<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends ConsumerState<OrderForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.saveAndValidate()) {
      ref
          .read(openOrdersProvider.notifier)
          .createOrder(_formKey.currentState!.value);
      widget.onfinished?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: widget.initialValues,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'symbol',
              decoration: const InputDecoration(labelText: 'Symbol'),
              readOnly: true,
            ),
            FormBuilderDropdown(
                name: 'side',
                decoration: const InputDecoration(labelText: 'Side'),
                items: [
                  DropdownMenuItem(value: 'BUY', child: const Text('Buy')),
                  DropdownMenuItem(value: 'SELL', child: const Text('Sell'))
                ]),
            FormBuilderDropdown(
              name: 'orderType',
              decoration: const InputDecoration(labelText: 'Order Type'),
              items: [
                DropdownMenuItem(value: 'LIMIT', child: const Text('Limit'))
              ],
            ),
            FormBuilderTextField(
              name: 'quantity',
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            FormBuilderTextField(
              name: 'price',
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitOrder,
                child: const Text('Submit'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () {
                    widget.onfinished?.call();
                  },
                  child: const Text('Cancel')),
            ),
          ],
        ),
      ),
    );
  }
}
